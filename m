Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967509AbaFQWUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:20:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965844AbaFQWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:20:21 -0400
Date: Tue, 17 Jun 2014 15:20:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: make rootdelay=N consistent with rootwait
 behaviour
Message-Id: <20140617152020.f23032953c83b621ded3901e@linux-foundation.org>
In-Reply-To: <1401904895-18791-1-git-send-email-paul.gortmaker@windriver.com>
References: <1401904895-18791-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 14:01:35 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Currently rootdelay=N and rootwait behave differently (aside
> from the obvious unbounded wait duration) because they are
> at different places in the init sequence.
> 
> The difference manifests itself for md devices because the
> call to md_run_setup() lives between rootdelay and rootwait,
> so if you try to use rootdelay=20 to try and allow a slow
> RAID0 array to assemble, you get this:
> 
> [    4.526011] sd 6:0:0:0: [sdc] Attached SCSI removable disk
> [   22.972079] md: Waiting for all devices to be available before autodetect
> 
> i.e. you've achieved nothing other than delaying the probing
> 20s, when what you wanted was a 20s delay _after_ the probing
> for md devices was initiated.
> 
> Here we move the rootdelay code to be right beside the rootwait
> code, so that their behaviour is consistent.
> 
> It should be noted that in doing so, the actions based on the
> saved_root_name[0] and initrd_load() were previously put on
> hold by rootdelay=N and now currently will not be delayed.
> However, I think consistent behaviour is more important than
> matching historical behaviour of delaying the above two operations.

hm.  There may be good reasons for inserting a delay between scsi init
and MD init - give things time to settle down before MD starts playing
with the disks?  And I think your patch takes away that option?


The kernel-parameters.txt documentation for these things is rather
vague.  We have three distinct phases, I think?

a) scsi init
b) [md init]
c) root mount

It's not terribly clear where rootdelay and rootwait are operating and
I expect there are gaps in the implementation anyway.

Do you think it's worth cleaning and clearing all this up in some fashion?

The whole thing is a bit of an admission of failure anyway, isn't it? 
Why should the kernel ever need to perform arbitrary dopey delays like
this?  Are we working around unresolved underlying bugs?

