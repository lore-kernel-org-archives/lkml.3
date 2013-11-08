Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3KHIvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:51:06 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:42173 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221Ab3KHIvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:51:02 -0500
Message-ID: <527CA5F3.7090605@vmware.com>
Date: Fri, 08 Nov 2013 09:50:59 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH RFC] dma-buf/fs Add get_[file|dma_buf]_unless_doomed
References: <1383895134-4535-1-git-send-email-thellstrom@vmware.com> <20131108080638.GA14082@phenom.ffwll.local>
In-Reply-To: <20131108080638.GA14082@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 09:06 AM, Daniel Vetter wrote:
> On Thu, Nov 07, 2013 at 11:18:54PM -0800, Thomas Hellstrom wrote:
>> In this context, a "doomed" object is an object whose refcount has reached
>> zero, but that has not yet been freed.
>>
>> To avoid mutual refcounting vmwgfx need to have a non-refcounted pointer to
>> a dma-buf in a lookup structure. The pointer is removed in the dma-buf
>> destructor. To allow lookup-structure private locks we need
>> get_dma_buf_unless_doomed(). This common refcounting scenario is described
>> with examples in detail in the kref documentaion.
>> The solution with local locks is under kref_get_unless_zero().
>> See also kobject_get_unless_zero() and its commit message.
>> Since dma-bufs are using the attached file for refcounting,
>> get_dma_buf_unless_doomed maps directly to a get_file_unless_doomed.
>>
>> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> I'm a bit confused ... why do we need this helper in common code? You can
> only synchronize the final release with your own locks for your own
> dma-bufs exported from vmwgfx. So I'm not sure at all whether we want this
> in common code.
It's for the following scenario

thread a                               thread b
dma_buf_put()
refcount reaches zero
                                             lock_lookup
                                             obtain dma_buf_pointer
                                             get_dma_buf() -> False 
reference
                                             unlock_lookup
lock_lookup
remove dma_buf_pointer
unlock lookup

There are two solutions to this. The bad one is to enclose also 
dma_buf_put() in lock_lookup which means we need to add an extra set of
shared locks to dmabuf, and we'd have to take the locks around *all* 
dma_buf_puts(). The good one is using get_dma_buf_unless_doomed(), which 
also opens up for rcu locking of the lookup had struct_file been freed 
using RCU synchronization semantics.
Both these scenarios are well documented in the kref docs, and this one 
should be pretty established by now, as seen by the kobj_get_unless_zero 
commit message from Linus. Nothing strange here.

>
> Also the gem/prime stuff gets by without this (and I have a pretty evil
> set of tests for it). The only current bug is that multiple imports of
> foreign objects (e.g. using a 2nd gpu to render, then import+share to the
> compositor) can still lead to some fun. But that's simply something I
> haven't gotten around to yet ...

I've looked closely at the gem/prime stuff, and AFAICT it's fully 
correct. The difference is that the lookup (gem::dma_buf) is referenced 
so it doesn't encounter this situation. The reference and lookup is 
removed with the gem name triggering dma_buf destruction and finally a 
free of the gem object.

This, however comes with two implications
1) Once a DMA-buf is added, it stays alive at least until someone 
removes the gem name of the exporting object, regardless whether there 
are any external users or not. I think this is OK, but unnecessary.
2) If someone decides to get a new handle from fd, and the gem name has 
already been removed, a new gem name is created for the exporting 
dma-buf by the requested client. This is why I can't do the same. 
Because of the relaxed RCU locking, I can't re-add a name to a TTM base 
object. Removing it is always part of the object destruction sequence.

/Thomas


> -Daniel
>
>> ---
>>   include/linux/dma-buf.h |   16 ++++++++++++++++
>>   include/linux/fs.h      |   15 +++++++++++++++
>>   2 files changed, 31 insertions(+)
>>
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index dfac5ed..6e58144 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -162,6 +162,22 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
>>   	get_file(dmabuf->file);
>>   }
>>   
>> +/**
>> + * get_dma_buf_unless_doomed - convenience wrapper for get_file_unless_doomed
>> + *
>> + * @dmabuf:	[in]	pointer to dma_buf
>> + *
>> + * Obtain a dma-buf reference from a lookup structure that doesn't refcount
>> + * the dma-buf, but synchronizes with its release method to make sure it has
>> + * not been freed yet. See for example kref_get_unless_zero documentation.
>> + * Returns true if refcounting succeeds, false otherwise.
>> + */
>> +static inline bool __must_check
>> +get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
>> +{
>> +	return get_file_unless_doomed(dmabuf->file);
>> +}
>> +
>>   struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>>   							struct device *dev);
>>   void dma_buf_detach(struct dma_buf *dmabuf,
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 3f40547..a96c333 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -824,6 +824,21 @@ static inline struct file *get_file(struct file *f)
>>   	atomic_long_inc(&f->f_count);
>>   	return f;
>>   }
>> +
>> +/**
>> + * get_file_unless_doomed - convenience wrapper for get_file_unless_doomed
>> + * @file:	[in]	pointer to file
>> + *
>> + * Obtain a file reference from a lookup structure that doesn't refcount
>> + * the file, but synchronizes with its release method to make sure it has
>> + * not been freed yet. See for example kref_get_unless_zero documentation.
>> + * Returns true if refcounting succeeds, false otherwise.
>> + */
>> +static inline bool __must_check get_file_unless_doomed(struct file *f)
>> +{
>> +	return atomic_long_inc_not_zero(&f->f_count) != 0L;
>> +}
>> +
>>   #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
>>   #define file_count(x)	atomic_long_read(&(x)->f_count)
>>   
>> -- 
>> 1.7.10.4
>>
>> _______________________________________________
>> Linaro-mm-sig mailing list
>> Linaro-mm-sig@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
