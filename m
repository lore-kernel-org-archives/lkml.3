Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3BEKQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:16:05 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55071 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab3BEKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:16:00 -0500
Message-ID: <1360059358.1343.37.camel@x61.thuisdomein>
Subject: infiniband: cxgb4: GCC warnings for 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Feb 2013 11:15:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Feb 2013 10:15:58.0638 (UTC) FILETIME=[CAB1DCE0:01CE0389]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Compiling cm.o for 32 bit triggers these GCC warnings:
    drivers/infiniband/hw/cxgb4/cm.c: In function ‘passive_ofld_conn_reply’:
    drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    drivers/infiniband/hw/cxgb4/cm.c: In function ‘send_fw_pass_open_req’:
    drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    [last line repeated a number of times]

1) These two lines were added in commit
1cab775c3e75f1250c965feafd061d696df36e53 ("RDMA/cxgb4: Fix LE hash
collision bug for passive open connection"). That commit was first
released in v3.8-rc1. It's not obvious to me how to fix these warnings,
since these lines are a bit puzzling.

2) These lines read:
   rpl_skb = (struct sk_buff *)cpu_to_be64(req->cookie);

and:
   req->cookie = cpu_to_be64((u64)skb);

3) It is odd that both use cpu_to_be64(). It seems the first one should
have been be64_to_cpu().

But 'cookie' is of type __u64 (see struct
cpl_fw6_msg_ofld_connection_wr_rpl in
drivers/net/ethernet/chelsio/cxgb4/t4_msg.h). So the use of both that
type and the cpu_to_be64() macro looks a bit odd too.

And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? Is
there a requirement for it to be 64 bits wide on both 32 bit and 64 bit?


Paul Bolle

