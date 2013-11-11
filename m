Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3KKQQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:16:03 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36139 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782Ab3KKQQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:16:00 -0500
Message-ID: <528102BD.90207@vmware.com>
Date: Mon, 11 Nov 2013 17:15:57 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC RESEND] dma-buf/fs Add get_[file|dma_buf]_unless_doomed
References: <1384160267-3389-1-git-send-email-thellstrom@vmware.com> <20131111151704.GX13318@ZenIV.linux.org.uk>
In-Reply-To: <20131111151704.GX13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 04:17 PM, Al Viro wrote:
> On Mon, Nov 11, 2013 at 12:57:47AM -0800, Thomas Hellstrom wrote:
>> Resending since it appears this RFC never got to the dri-devel lkml lists.
>>
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
> NAK for struct file.  This kind of stuff is for implementing primitives,
> not as a public API.

That's only partially correct. Public access (through in this case a 
release callback) to the object destructor validates a public 
ref_unless_doomed method. It's particularly useful if an external user 
wants to implement a lookup table for objects that are removed from the 
table in the object destructor or, (which doesn't apply in this case) 
using RCU locks for lookups.

Still want to NAK this, could you please elaborate a bit more why you 
don't want it in? Fear of misuse or general dislike of this
lookup method?

>   BTW, as for dmabuf...  dma_buf_fd() calling conventions
> are seriously misguided - we are trying to transfer the reference we hold
> into something (in this case - descriptor table), so the failure exit
> should be dropping the reference, not leaving that to caller

You're probably right, though I'm only a dma_buf API user, trying to 
extend the dma_buf API useful for my use-case.

Thanks,
Thomas
