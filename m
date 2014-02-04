Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaBDBip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:38:45 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17497 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaBDBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:38:43 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-52-52f044a175cb
Message-id: <52F04488.4060202@partner.samsung.com>
Date: Mon, 03 Feb 2014 17:38:16 -0800
From: Daniel Phillips <d.phillips@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>
Subject: Tux3 Report: Our blocker list
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9hX92FLh+CDA7t0bTYs/cki8XlXXPY
	LD4c+MzowOzx7ekrNo/Pm+QCmKK4bFJSczLLUov07RK4Mh7Pyi7YIl/RPuUTWwPjf4kuRk4O
	CQETidZ9XYwQtpjEhXvr2boYuTiEBJYxSnRd/swI4fQySax8epUJwtnAKPFv1RIgh4ODV8BI
	Yu3+KJBuFgFVif2rtjCB2GwCZhJLj58Bs0UFIiRWLnnACmLzCghK/Jh8jwVkjojAckaJjq5d
	YEXCAmoSP54tBTuDWcBaYuWkbVC2vMTmNW+ZQWwhAV2Jv99+MEGcqiCx4sYblgmMArOQzJ2F
	pH0WkvYFjMyrGMVKi5MLipPSUyuM9IoTc4tL89L1kvNzNzFCQrR6B+PdrzaHGAU4GJV4eE8o
	fggSYk0sK67MPcQowcGsJMJ70AIoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTGn4uv5hv5UbW/t
	Xl6dp0+TOS32zkm8YhhZ0sFZvNJt/6yoKbv/SZWejWv7qX12ytUdc9UyL56afXt528+0lHsv
	D2c+Kps6w89/a7HLkdony7tqrq6IctCbd2fFa9/Hk/ysWMtuFtXZqh59dmODLs+fNOEYs6b7
	PnyHlnrueXQ9/HbnsqRu5mlKLMUZiYZazEXFiQDeJyzVLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Korea Linux Forum last fall, Linus asked, haven't I been hearing
about Tux3 for ten years? I said, no, that was Tux2, completely
different. You only heard about Tux3 for six years.

Well, that is about long enough to keep hearing about an out of tree
filesystem. Last time we talked about merging, the main criticisms were
stylistic things, long since fixed. After that, we decided to address
some glaring issues rather than let innocent victims hit them the hard
way. Though victims of a new filesystem are theoretically limited to
battle hardened veterans, in practice it does not work out that way. In
reality, if you just need to flip a config flag then all kinds of
people will try the code. If it then does stupid things it immediately 
acquires a reputation that could take years to shake. Not fun. So we 
decided to fill in some holes first.

Here is our remaining blocker list:

  1) Allocation policy: simple minded linear block allocation is good
     for benchmarks but ages poorly, so add a respectable allocation
     policy.

  2) Mmap consistency: mmap writes may interact with block forking
     caused by write(2) to leave stale pages in cache - fix it.

  3) ENOSPC: Volume full conditions must be predicted by the frontend,
     not detected in the backend when it is too late to enforce ACID
     guarantees, and the prediction must be accurate or users will be
     annoyed by ENOSPC errors on a volume that is far from full.

After that, plenty of issues remain before anyone should deploy Tux3 for
real work, however none are in the "fill up your volume and it eats
itself" category. Items 1 and 2 above are nearly done and item 3 is
designed in detail, so we are close to a flag day where we offer up the 
Tux3 patch for serious review.

You can watch our progress here:

     https://github.com/OGAWAHirofumi/tux3/commits/hirofumi

and here:

    http://buildbot.tux3.org:8010/waterfall

This is the amazing test infrastructure Hirofumi set up using buildbot
and hardware contributed by Miracle Linux. It goes to work whenever new
patches arrive on Github. You can see it testing the allocation patches
that landed this weekend.

One thing that happened over the last couple of months is, we added
allocation group counts and thus adopted yet another main design
feature of Ext4. This required some new, persistent metadata, with a
risk of regressing our benchmarks, but we will actually end up more
efficient for reasons I will delve into on the Tux3 mailing list.

Incidentally, the Tux3 kernel patch grew very little over the last
year. In spite of many improvements, we remain just over 18K lines of
code including whitespace. By comparison, Ext4 is 52K, Btrfs is 94K and
XFS is 96K. Though none of these can be reasonably described as
bloated, Tux3 is tighter by a multiple.

Overall, we tend to devote as much work to removing code as adding it.
As a result, we think Tux3 upholds the traditional Unix Philosophy
pretty well. Though it is fashionable to attack this time honored credo
on the basis of practicality, you can have orthogonal design and great
functionality too. We view lightness and tightness as a major
contribution, ranking just as high as performance and resilience. This
is about both maintainability and personal satisfaction.

We do expect our code base to grow faster as the focus shifts from base
functionality to features and scaling. To name a few: snapshots; data
compression; directory indexing; online repair; quotas. But we also have
opportunities to remove code, so a year from now I expect a code base
that is only modestly bigger and includes most of this list.

Interested developers and testers are welcome to drop by for a chat:

     http://tux3.org/contribute.html
     irc.oftc.net #tux3

With most of the tedious groundwork out of the way, this is the fun
part of the process where we get to obsess endlessly over matters of
fit and finish.

Regards,

Daniel

