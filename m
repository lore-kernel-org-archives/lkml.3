Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaL3DVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:21:03 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49952 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaL3DVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:21:01 -0500
Message-ID: <1419909649.14143.86.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: Christophe Fillot <cf@utc.fr>, linux-ima-user@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 29 Dec 2014 22:20:49 -0500
In-Reply-To: <54A2062C.2030909@landley.net>
References: <5463ABC8.10308@utc.fr>
	 <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <547617AF.6000604@utc.fr>
	 <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5476EBAC.8090103@utc.fr>
	 <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54A1BAEE.6000101@landley.net>
	 <1419889608.14143.40.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54A2062C.2030909@landley.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123003-0025-0000-0000-000000D60CFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-29 at 19:55 -0600, Rob Landley wrote: 
> 
> On 12/29/2014 03:46 PM, Mimi Zohar wrote:
> > On Mon, 2014-12-29 at 14:34 -0600, Rob Landley wrote: 
> >> On 12/29/2014 07:45 AM, Mimi Zohar wrote:
> >>> On Thu, 2014-11-27 at 10:15 +0100, Christophe Fillot wrote:
> >>>>>
> >>>>> Are you using an initrd not an initramfs?  According to
> >>>>> Documentation/filesystems/ramfs-rootfs-initramfs.txt, "If
> >>>> CONFIG_TMPFS
> >>>>> is enabled, rootfs will use tmpfs instead of ramfs by default".
> >>>>>
> >>>> Yes, that what I thought too, but it seems that it is not really the 
> >>>> case because of this test:
> >>>>
> >>>>      if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
> >>>>          (!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
> >>>>          err = shmem_init();
> >>>>          is_tmpfs = true;
> >>>>      } else {
> >>>>          err = init_ramfs_fs();
> >>>>      }
> >>>
> >>> [CC'ing Rob Landley, lsm, lkml]
> >>>
> >>> Thanks!  "saved_root_name" is set to the boot command line "root="
> >>> option, which in my case is the UUID.  I'm not sure why real root should
> >>> impact the initramfs tmpfs/ramfs decision.
> >>>
> >>> Unless there is a good explanation, did you want to post a patch to
> >>> remove the test?
> >>
> >> I added support last year, here's the start of the patch series:
> >>
> >>   https://lkml.org/lkml/2013/6/29/101
> >>
> >> The logic is that if you specify a fallback root via root=, then you're
> >> not staying on rootfs (that's what root= _means_, "here is the root
> >> filesystem the kernel is to mount over rootfs"), and thus the extra
> >> infrastructure for tmpfs instead of ramfs is unnecessary.
> > 
> > Thanks Rob for the explanation.  The problem is that ramfs does not
> > support extended attributes, while tmpfs does.
> 
> If you're _using_ initramfs/initmpfs, there's no reason to specify a root=.

The menu entry looks like:
linux   /vmlinuz-3.17.0+ root=UUID=94595ff7-0fd4-4ea3-99f2-f7ddf8fbc91f
ro  ...
initrd  /initramfs-3.17.0+.img

Because "root=" is specified, rootfs is not using tmpfs.

> > The boot loader could
> > "measure" (trusted boot) the initramfs, but as the initramfs is
> > generated on the target system, the initramfs is not signed, preventing
> > it from being appraised (secure Boot). To close the initramfs integrity
> > appraisal gap requires verifying the individual initramfs file
> > signatures, which are stored as extended attributes.
> 
> Faced with the phrases "trusted boot" and "integrity appraisal", I plead
> the third.

Fine.  Bottom line, rootfs needs to support extended attributes.

> (In the wake of the Snowden infodump,

All the more reason to allow only those files that are properly signed
to be read/executed.

Mimi

