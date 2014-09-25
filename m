Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIYOAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:00:02 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1721 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbaIYOAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:00:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,597,1406563200"; 
   d="scan'208";a="36467736"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        David Howells <dhowells@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Thread-Topic: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Thread-Index: AQHP195u16fgq2K+Ek2axoqmdIkT2JwRzrJw
Date: Thu, 25 Sep 2014 12:52:56 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5C4C2D@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8PE08nY023157

Hi,

	Any comments?

Thanks,
- Chen

> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> Subject: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according to ns
> 
> If some issues occurred inside a container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
> 
> This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
> a) In init_pid_ns, nothing changed;
> 
> b) In one pidns, will tell the pid inside containers:
> NStgid:	21776   5       1
> NSpid:  21776   5       1
> NSpgid:	21776   5       1
> NSsid:  21729   1       0
> ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.
> 
> c) If pidns is nested, it depends on which pidns are you in.
> NStgid: 5       1
> NSpid:  5       1
> NSpgid: 5       1
> NSsid:  1       0
> ** Views from level 1
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
> v3: add another two fielsd: NSpgid and NSsid.
> v2: add two new fields: NStgid and NSpid.
>     keep fields of Tgid and Pid unchanged for back compatibility.
> 
>  fs/proc/array.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index cd3653e..c30875d 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -193,6 +193,23 @@ static inline void task_state(struct seq_file *m, struct
> pid_namespace *ns,
>  		from_kgid_munged(user_ns, cred->egid),
>  		from_kgid_munged(user_ns, cred->sgid),
>  		from_kgid_munged(user_ns, cred->fsgid));
> +	seq_puts(m, "NStgid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_tgid_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSpid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_pid_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSpgid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_pgrp_nr_ns(p, pid->numbers[g].ns));
> +	seq_puts(m, "\nNSsid:");
> +	for (g = ns->level; g <= pid->level; g++)
> +		seq_printf(m, "\t%d ",
> +			task_session_nr_ns(p, pid->numbers[g].ns));
> +	seq_putc(m, '\n');
> 
>  	task_lock(p);
>  	if (p->files)
> --
> 1.9.0
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
