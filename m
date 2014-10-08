Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaJHUli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:41:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56778 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaJHUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:41:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Wed, 08 Oct 2014 22:41:23 +0200
Message-ID: <1790241.KrvEcO3C6i@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xMi9igk5XDT9fb2Rj/WdTkok6y02La+eZxupu9FjgIR
 Y1A8NbwakyOjEiVEjdbpmG9HKstTErtkDthe+CRYg0oGWRYKZn
 FVWWCU+uGT2RgidGvQGFFEN0/LNE0V0BaNR/a8GyJ2mqfNuqt0
 CNBbdunMV/7yqrV7Gq85Nax5pUYUuzLMTOb82pKOwXKiJ6JGnO
 ZbOyyw6qt7COaZWJmHR21Ol3U4t4OUSCLebebKFdDttbs/+9kq
 vfdmFYfrs8oLh9hwtvGS/JGTuj6+r/mFnR2/Ai55H8+WlNnzIN
 g+vHA4PJhoy/yO0u8opnYogRfV6COGcCsEmHdROHmJc1m1se8M
 EY8wAfah/buRuIsI4QX4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 23:14:08 Ebru Akagunduz wrote:
> This patch changes 32-bit time types to 64-bit in
> ips.c
> 
> time_t can only represent signed 32-bit dates but
> the driver should represent dates that are after
> January 2038.
> 
> Use time64_t type instead of time_t.
> 
> Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
> 

Hi Ebru,

I think you missed the location in which ffdc_time is initially
assigned, and wher it gets compared to the current time:

                struct timeval tv;

                do_gettimeofday(&tv);
                ha->last_ffdc = tv.tv_sec;

This needs to be changed to timespec64 to actually avoid the
overflow problem. I think this one should also use monotonic time,
i.e. ktime_get_ts64 rather than getnstimeofday64.

	Arnd
