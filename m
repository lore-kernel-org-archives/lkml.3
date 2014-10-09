Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaJIEOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:14:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60377 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800AbaJIEO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:14:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,682,1406563200"; 
   d="scan'208";a="36992636"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] setns: return 0 directly if try to reassociate with
 current namespace
Thread-Topic: [PATCH RFC] setns: return 0 directly if try to reassociate
 with current namespace
Thread-Index: AQHP4yEw4NpWZCYqHEKFGoSbryV/9pwnI/tQ
Date: Thu, 9 Oct 2014 04:14:23 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5E0FAC@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<20141008145740.GD30569@ubuntumail> <87r3yih2e2.fsf@x220.int.ebiederm.org>
In-Reply-To: <87r3yih2e2.fsf@x220.int.ebiederm.org>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s994EhAU028508



> -----Original Message-----
> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Thursday, October 09, 2014 1:56 AM
> 
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> >> We could use setns to join the current ns,
> >> which did a lot of unnecessary work.
> >> This patch will check this senario and
> >> return 0 directly.
> >>
> >> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> >
> > Plus it's just asking for trouble.
> >
> > I would ack this, except you need to fclose(file) on the
> > return paths.  So just set err = 0 and goto out.
> 
> I completely disagree.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This patch adds a new code path to test, and gets that new code path
> wrong.  So unless there is a performance advantage for some real world
> case I don't see the point.  Is there real software that is rejoining
> the a current namespace.
> 
> This patch changes the behavior of CLONE_NEWNS (which always does a
> chdir and chroot) when you change into the current namespace.
> 
> This patch changes the behavior of CLONE_NEWUSER which current errors
> out.
> 

As reentering the same namespace looks meaningless,
and handling reentering same ns we behaved differently,
 
How about just *reject* the behaviour of setns to current namespace?

+	switch (ops->type) {
+	case CLONE_NEWIPC:
+		if (ei->ns == tsk->nsproxy->ipc_ns) {
+            err = -EINVAL;
+			goto out;
+        }
...

And things became easy, 6 simply cases could cover the whole scenario
and will not bring troubles to users.

Thanks,
- Chen

> This code adds a big switch statement to code that is otherwise table
> driven.  With the result that two pieces of code must be looked at
> and modified whenever we want to tweak the behavior of setns for a
> namespace.
> 
> So in general I think this piece of code is a maintenance disaster,
> with no apparent redeem virtues.
> 
> Eric
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
