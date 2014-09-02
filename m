Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaIBIo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:44:58 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:52383 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaIBIo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:44:56 -0400
Message-ID: <54058376.9090700@mentor.com>
Date: Tue, 2 Sep 2014 14:14:38 +0530
From: Harish Jenny Kandiga Nagaraj <harish_kandiga@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <dborkman@redhat.com>, <tgraf@suug.ch>, <ebiederm@xmission.com>,
        <darkjames-ws@darkjames.pl>, <rgb@redhat.com>,
        <eric.dumazet@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netlink: Safer deletion of sk_bind_node
References: <1409555309-5893-1-git-send-email-harish_kandiga@mentor.com> <20140901.220325.955861172520355423.davem@davemloft.net>
In-Reply-To: <20140901.220325.955861172520355423.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one of our random test runs we observed the crash mentioned in the previous mail.

After debugging we found out that the call flow of the inline and static functions were
netlink_release
-----netlink_remove
---------__sk_del_bind_node
--------------__hlist_del

*pprev was NULL in __hlist_del function while deleting &sk->sk_bind_node hlist_node. Hence the patch was given.

In netlink_remove function , first the sk_del_node_init function will be called. This internally calls __sk_del_node_init function. While deleting &sk->sk_node hlist_node using __sk_del_node function there is a NULL check with sk_hashed function.

Why there is no NULL check for *pprev while deleting &sk->sk_bind_node ?

On Tuesday 02 September 2014 10:33 AM, David Miller wrote:
> From: Harish Jenny K N
> Date: Mon, 1 Sep 2014 12:38:29 +0530
>
> Firstly, you really need to fix your outgoing email so that your email
> address appears in your From: header properly.
>
>> From: Harish Jenny K N <harish_kandiga@mentor.com>
>>
>>     Unable to handle kernel NULL pointer dereference at virtual address 00000000
>>         (netlink_release+0x0/0x2a0) from [<8034e78c>] (sock_release+0x28/0xa4)
>>         (sock_release+0x0/0xa4) from [<8034e830>] (sock_close+0x28/0x34)
>>         (sock_close+0x0/0x34) from [<800f3490>] (__fput+0xf0/0x1ec)
>>         (__fput+0x0/0x1ec) from [<800f3634>] (____fput+0x10/0x14)
>>         (____fput+0x0/0x14) from [<80040a64>] (task_work_run+0xb8/0xd8)
>>         (task_work_run+0x0/0xd8) from [<800113a0>] (do_work_pending+0xb0/0xc4)
>>         (do_work_pending+0x0/0xc4) from [<8000d960>] (work_pending+0xc/0x20)
>>     Call flow of the inline and static functions
>>         netlink_release
>>         -----netlink_remove
>>         ---------__sk_del_bind_node
>>         --------------__hlist_del
>>
>> Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
> This doesn't tell us anything about how this situation can be
> arrived at.
>
> When subscriptions changes, we delete the node with the table lock
> held if subscriptions goes to zero.  We only try to delete the node
> when subscriptions was zero.

