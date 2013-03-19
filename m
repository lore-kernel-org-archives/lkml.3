Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3CSLcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:32:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38826 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab3CSLcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:32:13 -0400
Message-ID: <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        pbonzini@redhat.com
Date: Tue, 19 Mar 2013 11:32:07 +0000
In-Reply-To: <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	 <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:57 +0800, Wanlong Gao wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> virtio_scsi_target_state is now empty.  We will find new uses for it in
> the next few patches, so this patch does not drop it completely.
> However, having dropped the sglist flexible array member, we can turn
> the tgt array-of-pointers into a simple array.  This simplifies the
> allocation.
> 
> Even simpler would be to place the virtio_scsi_target_state structs in a
> flexible array member at the end of struct virtio_scsi.  But we do not
> do that, because we will place the virtqueues there in the next patches.

I'm really sorry, but I must have been asleep at the wheel when I let
code like this go in.  No modern driver should have fixed arrays for
target information.  The way this is supposed to work is that you have
entries in the host template for target_alloc and target_destroy.  You
hook into these and attach your struct virtio_scsi_target_state to
scsi_target->hostdata, which you kmalloc in the target_alloc routine and
kfree in the target_destroy routine.  Now you get at it from the sdev
with scsi_target(sdev)->hostdata. No messing around with fixed size
arrays and bulk memory allocation and no need to pass in the maximum
target size as a parameter because everything should now happen
dynamically.

Since you're redoing the code anyway, can you fix it to work this way?

Thanks,

James


