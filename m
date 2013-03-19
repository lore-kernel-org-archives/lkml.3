Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3CSLpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3CSLp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:45:29 -0400
Message-ID: <51484FC2.6030601@redhat.com>
Date: Tue, 19 Mar 2013 12:45:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com
Subject: Re: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>  <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com> <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/03/2013 12:32, James Bottomley ha scritto:
> On Tue, 2013-03-19 at 17:57 +0800, Wanlong Gao wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> virtio_scsi_target_state is now empty.  We will find new uses for it in
>> the next few patches, so this patch does not drop it completely.
>> However, having dropped the sglist flexible array member, we can turn
>> the tgt array-of-pointers into a simple array.  This simplifies the
>> allocation.
>>
>> Even simpler would be to place the virtio_scsi_target_state structs in a
>> flexible array member at the end of struct virtio_scsi.  But we do not
>> do that, because we will place the virtqueues there in the next patches.
> 
> I'm really sorry, but I must have been asleep at the wheel when I let
> code like this go in.  No modern driver should have fixed arrays for
> target information.  The way this is supposed to work is that you have
> entries in the host template for target_alloc and target_destroy.  You
> hook into these and attach your struct virtio_scsi_target_state to
> scsi_target->hostdata,

So that would be sc->device->sdev_target->hostdata.

> which you kmalloc in the target_alloc routine and
> kfree in the target_destroy routine.  Now you get at it from the sdev
> with scsi_target(sdev)->hostdata. No messing around with fixed size
> arrays and bulk memory allocation and no need to pass in the maximum
> target size as a parameter because everything should now happen
> dynamically.

The maximum target size is not a module parameter, it is given by the
host; so the module itself is not placing arbitrary limitation.  Still
it is a good idea to do it like this.

Thanks for the review.

Paolo

> Since you're redoing the code anyway, can you fix it to work this way?
> 
> Thanks,
> 
> James
> 
> 

