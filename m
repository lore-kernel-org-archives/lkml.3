Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LKRTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:19:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3LKRTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:19:04 -0500
Date: Wed, 11 Dec 2013 12:18:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ethan Zhao <ethan.kernel@gmail.com>, pjones@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in
 iscsi_boot_destroy_kset()
Message-ID: <20131211171819.GB8078@phenom.dumpdata.com>
References: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
 <20131209213057.GA11314@phenom.dumpdata.com>
 <CABawtvMGOJg5DPRwdWAOSTkxgurv5bx8n=3yJFOq=aagxzseZQ@mail.gmail.com>
 <74430a05-1640-4174-977d-52d2d2b8519f@email.android.com>
 <52A7618C.3050308@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7618C.3050308@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:46:36PM -0600, Mike Christie wrote:
> On 12/10/13 8:11 AM, Konrad Rzeszutek Wilk wrote:
> >Ethan Zhao <ethan.kernel@gmail.com> wrote:
> >>Konrad,
> >>
> >>boot_kset was allocated when module loaded by
> >>ibft_init()
> >>  iscsi_boot_create_kset()
> >>     kzalloc()
> >>
> >>but wasn't freed when module unloaded by
> >>ibft_exit()
> >>   ibft_cleanup()
> >>     iscsi_boot_destroy_kset()
> >>
> >>Thanks,
> >>Ethan
> >>
> >>On Tue, Dec 10, 2013 at 5:30 AM, Konrad Rzeszutek Wilk
> >><konrad.wilk@oracle.com> wrote:
> >>>On Mon, Dec 09, 2013 at 05:37:11PM +0800, Ethan Zhao wrote:
> >>>>From: "Ethan Zhao" <ethan.kernel@gmail.com>
> >>>>
> >>>>Load and unload iscsi_ibft module will cause kernel memory leak, fix
> >>it
> >>>>in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().
> >>>>
> >>>
> >>>Is there a stack trace?
> >>>>Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> >>>>---
> >>>>  drivers/scsi/iscsi_boot_sysfs.c | 1 +
> >>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>>diff --git a/drivers/scsi/iscsi_boot_sysfs.c
> >>b/drivers/scsi/iscsi_boot_sysfs.c
> >>>>index 14c1c8f..680bf6f 100644
> >>>>--- a/drivers/scsi/iscsi_boot_sysfs.c
> >>>>+++ b/drivers/scsi/iscsi_boot_sysfs.c
> >>>>@@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct
> >>iscsi_boot_kset *boot_kset)
> >>>>               iscsi_boot_remove_kobj(boot_kobj);
> >>>>
> >>>>       kset_unregister(boot_kset->kset);
> >>>>+     kfree(boot_kset);
> >>>>  }
> >>>>  EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
> >>>>--
> >>>>1.8.3.4 (Apple Git-47)
> >>>>
> >
> >Right. In the past we did not do that b/c certain drivers (like broadcom) would allocate on the kset their name and try to free (the driver would after freeing the ibft). So you would end up with this patch a double free ( and it might be fixed by now but I can't recall).
> >
> 
> Do you mean the name string that is passed into kset_create_and_add?

Yes.
> If so that should not happen now. There does not seem to be any user
> freeing that string.
> 
> There used to be bug where at the initiator/target/ethernet level
> there was a double free because iscsi_boot_sysfs and be2iscsi were
> both freeing the struct associated with the
> initiator/target/ethernet. That is fixed in
> f457a46f179df41b0f6d80dee33b6e629945f276.

That is the one!
> 
> 
