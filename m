Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaHDQ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:29:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39230 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaHDQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:29:08 -0400
Date: Mon, 4 Aug 2014 09:29:04 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: <lichunhe@huawei.com>
Cc: <vyasevic@redhat.com>, <xiyou.wangcong@gmail.com>,
        <makita.toshiaki@lab.ntt.co.jp>, <mst@redhat.com>,
        <ebiederm@xmission.com>, <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>, <wuyunfei@huawei.com>,
        <qianhuibin@huawei.com>
Subject: Re: [PATCH net/next] bridge:Add rcu read lock when delete br port
Message-ID: <20140804092904.16654a4c@haswell.linuxnetplumber.net>
In-Reply-To: <1407123476-9720-1-git-send-email-lichunhe@huawei.com>
References: <1407123476-9720-1-git-send-email-lichunhe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014 11:37:56 +0800
<lichunhe@huawei.com> wrote:

> From: Chunhe Li <lichunhe@huawei.com>
> 
> In the br_hanle_frame function has a bug, when the bridge receive packets
> which go througth the br_handle_frame, get the net_bridge_port pointer "p",
> but don't check NULL pointer to use it. If somebody delete the bridge port
> at the same time, will call a NULL pointer, trigger kernel panic. I see the
> del_nbp comments, call del_nbp should via RCU, but the caller don't do this.
> 
> following steps will make bug happened
> 1.start vm and add the vm interface to a bridge br0,for example,
> brctl addbr br0 tap0
> 
> 2.configuer vm interface and br0 same ip subnet, vm ping br0.
> 
> 3.add and delete the vm interface port for endless loop.
> 
> Signed-off-by: Chunhe Li <lichunhe@huawei.com>

This is safe because:
 1. br_dev_delete is called with RTNL mutex therefore it is safe with other add/delete
    RCU does not block anything
 2. br_handle_frame is called with RCU lock (in frame rx)
 3. port is not freed until after grace period
