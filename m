Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbaFUDzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 23:55:00 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:47041 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbaFUDy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 23:54:59 -0400
Message-ID: <53A50218.6020506@dev.rtsoft.ru>
Date: Sat, 21 Jun 2014 07:55:04 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: "'Alexey Lugovskoy'" <lugovskoy@dev.rtsoft.ru>,
        Konstantin Kholopov <kkholopov@dev.rtsoft.ru>,
        linux-kernel@vger.kernel.org
Subject: [v3.10-rt / v3.12-rt] scheduling while atomic in cgroup code
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Call Trace:
[e22d5a90] [c0007ea8] show_stack+0x4c/0x168 (unreliable)
[e22d5ad0] [c0618c04] __schedule_bug+0x94/0xb0
[e22d5ae0] [c060b9ec] __schedule+0x530/0x550
[e22d5bf0] [c060bacc] schedule+0x30/0xbc
[e22d5c00] [c060ca24] rt_spin_lock_slowlock+0x180/0x27c
[e22d5c70] [c00b39dc] res_counter_uncharge_until+0x40/0xc4
[e22d5ca0] [c013ca88] drain_stock.isra.20+0x54/0x98
[e22d5cc0] [c01402ac] __mem_cgroup_try_charge+0x2e8/0xbac
[e22d5d70] [c01410d4] mem_cgroup_charge_common+0x3c/0x70
[e22d5d90] [c0117284] __do_fault+0x38c/0x510
[e22d5df0] [c011a5f4] handle_pte_fault+0x98/0x858
[e22d5e50] [c060ed08] do_page_fault+0x42c/0x6fc
[e22d5f40] [c000f5b4] handle_page_fault+0xc/0x80

What happens:

- refill_stock() calls get_cpu_var() and thus disables preemption until
matching put_cpu_var() is called,

- then it calls drain_stock() -> res_counter_uncharge() ->
res_counter_uncharge_until()

- and here we have spin_lock(), which under RT can sleep. Thus we have 
sleeping with preemption disabled.


Any ideas how to fix?
