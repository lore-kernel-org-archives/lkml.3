Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaI2Xa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:30:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56030 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaI2Xa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:30:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ross Lagerwall <rosslagerwall@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20140926233125.GA6918@hobo.lan>
Date: Mon, 29 Sep 2014 16:30:31 -0700
In-Reply-To: <20140926233125.GA6918@hobo.lan> (Ross Lagerwall's message of
	"Sat, 27 Sep 2014 00:31:25 +0100")
Message-ID: <87iok657jc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+0Uw2AEhQg0UR7AaYplwHQDlaL5tWEw+0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ross Lagerwall <rosslagerwall@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2274 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.1 (0.1%), b_tie_ro: 2.3 (0.1%), parse: 0.62 (0.0%),
	extract_message_metadata: 4.6 (0.2%), get_uri_detail_list: 2.4 (0.1%),
	tests_pri_-1000: 3.8 (0.2%), tests_pri_-950: 1.27 (0.1%), tests_pri_-900:
	1.05 (0.0%), tests_pri_-400: 15 (0.7%), check_bayes: 14 (0.6%), b_tokenize:
	4.1 (0.2%), b_tok_get_all: 4.8 (0.2%), b_comp_prob: 1.47 (0.1%),
	b_tok_touch_all: 1.86 (0.1%), b_finish: 0.63 (0.0%), tests_pri_0: 2224
	(97.8%), tests_pri_500: 4.8 (0.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: Mount propagation issue
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Lagerwall <rosslagerwall@gmail.com> writes:

> Hi,
>
> I have encountered a strange bug (on 3.14, 3.16.3 and master) regarding
> mount namespaces and a particular directory.  Somehow, mounts are being
> mounted successfully but disappearing when the process dies, but only
> for /mnt/puppy, not for any other directory in the system:
>
> # grep puppy /proc/mounts            # nothing mounted yet
> # mount -t tmpfs tmpfs /mnt/puppy
> # grep puppy /proc/mounts            # no output
>
> # mount -t tmpfs tmpfs /mnt/puppy2
> # grep puppy /proc/mounts
> tmpfs /mnt/puppy2 tmpfs rw,relatime 0 0
>
> Furthermore, I wrote a program to mount /mnt/puppy and immediately
> read /proc/mounts:
> # grep puppy /proc/mounts            # no output
> # ./mounter
> tmpfs /mnt/puppy tmpfs rw,relatime 0 0
> # grep puppy /proc/mounts            # no output
>
> Finally, I note that the problem seems to occur if the mount needs to be
> propagated to the default namespace (note that systemd causes namespaces
> to be shared by default):
> # unshare -m
>
> subshell # mount -t tmpfs tmpfs /mnt/puppy
> subshell # grep puppy /proc/mounts   # no output
> subshell # mount --make-rprivate /
> subshell # mount -t tmpfs tmpfs /mnt/puppy
> subshell # grep puppy /proc/mounts   # success!
> tmpfs /mnt/puppy tmpfs rw,relatime 0 0
> subshell # umount /mnt/puppy
> subshell # exit
>
> # mount --make-rprivate /            # back in the default namespace
> # mount -t tmpfs tmpfs /mnt/puppy
> # grep puppy /proc/mounts            # no output
>
> I hope someone has an idea of what's going on or how to debug this
> because I've run out of ideas...

My guess is that some process (systemd?) is configured to unmount that
directory if anything shows up mounted on it.  So when the mount
propogates it gets unmounted and then the unmount propogates as well.

Eric

