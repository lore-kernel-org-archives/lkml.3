Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaAVGD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:03:28 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:46025 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaAVGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:02:58 -0500
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 14:02:57 +0800
Message-ID: <CAFgnuDdOKxzFSDCBQTGw=p_t0CvKfjVEudttOCP_wrzyA2K1Og@mail.gmail.com>
Subject: mutual exculsion between clk_prepare_enable /clk_disable_unprepare
 and clk_set_parent
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: mturquette@linaro.org
Cc: Xiaoguang Chen <chenxg@marvell.com>, Zhoujie Wu <zjwu@marvell.com>,
        cxie4@marvell.com, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lucao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

We met a issue between clk_prepare_enable /clk_disable_unprepare and
clk_set_parent.

As we know, clk preprare/unprare will grab preprare lock, and clk
enable/disable will grab enable lock. clk_set_parent will grab prepare
lock

but there is no lock protection in clk_prepare_enable /clk_disable_unprepare,
for example, in clk_disable_unprepare, it is expended as clk_disable +
clk_unprepare,

and if below condition occurs, there will be problem
thread1                                                 thread 2
call clk_disable_unprepare
1) clk_disable
get enable lock
...............
release enable lock

                                                     call clk_set_parent
                                                     get prepare lock
                                                     set clock's
parent to another parent
                                                     release prepare lock

2) clk_unprepare
get prepare lock
unprepare parent clock <<--------------
release prepare lock

In above sequence, After thread 1 call clock disable, thread 2 change
clk's parent to another clock, then in thread1 step2, it will
unprepare clk's new parent, but not old parent, this will cause old
parent is not unprepared, but new parent is unprepared even when it is
not prepared yet.

So How can we use this API: clk_prepare_enable and clk_disable_unprepare  ?
Should we add lock to protect this API, if we get a prepare lock
inside this API, like
clk_disable_unprepare ()
{
get_prepare_lock();
clk_disable();
clk_unprepare();
clk_prepare_unlock();
}

is above sequence ok? if so, I can provide a patch for this.

Thanks
Xiaoguang
