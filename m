Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaG3WLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:11:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36827 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaG3WLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:11:09 -0400
Date: Wed, 30 Jul 2014 15:11:07 -0700 (PDT)
Message-Id: <20140730.151107.1328294951387764830.davem@davemloft.net>
To: mcgrof@do-not-panic.com
Cc: gregkh@linuxfoundation.org, tiwai@suse.de, linux-kernel@vger.kernel.org,
        mcgrof@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        joseph.salisbury@canonical.com, kay@vrfy.org,
        gnomes@lxorguk.ukuu.org.uk, tim.gardner@canonical.com,
        pierre-fersing@pierref.org, akpm@linux-foundation.org, oleg@redhat.com,
        bpoirier@suse.de, nagalakshmi.nandigama@avagotech.com,
        praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com,
        abhijit.mahajan@avagotech.com, hariprasad@chelsio.com,
        santosh@chelsio.com, MPT-FusionLinux.pdl@avagotech.com,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] driver core: enable drivers to use deferred
 probe from init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406572110-26823-3-git-send-email-mcgrof@do-not-panic.com>
References: <1406572110-26823-1-git-send-email-mcgrof@do-not-panic.com>
	<1406572110-26823-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Jul 2014 15:11:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 28 Jul 2014 11:28:28 -0700

> Tetsuo bisected and found that commit 786235ee "kthread: make
> kthread_create() killable" modified kthread_create() to bail as
> soon as SIGKILL is received. This is causing some issues with
> some drivers and at times boot. Joseph then found that failures
> occur as the systemd-udevd process sends SIGKILL to modprobe if
> probe on a driver takes over 30 seconds. When this happens probe
> will fail on any driver, its why booting on some system will fail
> if the driver happens to be a storage related driver. Some folks
> have suggested fixing this by modifying kthread_create() to not
> leave upon SIGKILL [3], upon review Oleg rejected this change and
> the discussion was punted out to systemd to see if the default
> timeout could be increased from 30 seconds to 120. The opinion of
> the systemd maintainers is that the driver's behavior should
> be fixed [4]. Linus seems to agree [5], however more recently even
> networking drivers have been reported to fail on probe since just
> writing the firmware to a device and kicking it can take easy over
> 60 seconds [6]. Benjamim was able to trace the issues recently
> reported on cxgb4 down to the same systemd-udevd 30 second timeout [6].
> 
> This is an alternative solution which enables drivers that are
> known to take long to use deferred probe workqueue. This avoids
> the 30 second timeout and lets us annotate drivers with long
> init sequences.
> 
> As drivers determine a component is not yet available and needs
> to defer probe you'll be notified this happen upon init for each
> device but now with a message such as:
> 
> pci 0000:03:00.0: Driver cxgb4 requests probe deferral on init
> 
> You should see one of these per struct device probed.

It seems we're still discussing this.

I think I understand all of the underlying issues, and what I'll say
is that perhaps we should use what Greg KH requested but via a helper
that is easy to grep for.

I don't care if it's something like "module_long_probe_init()" and
"module_long_probe_exit()", but it just needs to be some properly
named interface which does the whole kthread or whatever bit.

Thanks.
