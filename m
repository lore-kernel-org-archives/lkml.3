Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3FZQd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:33:28 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55267 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FZQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:33:26 -0400
Message-ID: <1372264414.3301.198.camel@edumazet-glaptop>
Subject: Re: [PATCH v3.10-rc7] net: fix kernel deadlock with interface
 rename and netdev name retrieval.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 26 Jun 2013 09:33:34 -0700
In-Reply-To: <1372260222-8597-1-git-send-email-nschichan@freebox.fr>
References: <1372260222-8597-1-git-send-email-nschichan@freebox.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 17:23 +0200, Nicolas Schichan wrote:
> When the kernel (compiled with CONFIG_PREEMPT=n) is performing the
> rename of a network interface, it can end up waiting for a workqueue
> to complete. If userland is able to invoke a SIOCGIFNAME ioctl or a
> SO_BINDTODEVICE getsockopt in between, the kernel will deadlock due to
> the fact that read_secklock_begin() will spin forever waiting for the
> writer process (the one doing the interface rename) to update the
> devnet_rename_seq sequence.
> 
> This patch fixes the problem by adding a helper (netdev_get_name())
> and using it in the code handling the SIOCGIFNAME ioctl and
> SO_BINDTODEVICE setsockopt.
> 
> The netdev_get_name() helper uses raw_seqcount_begin() to avoid
> spinning forever, waiting for devnet_rename_seq->sequence to become
> even. cond_resched() is used in the contended case, before retrying
> the access to give the writer process a chance to finish.
> 
> The use of raw_seqcount_begin() will incur some unneeded work in the
> reader process in the contended case, but this is better than
> deadlocking the system.
> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---

This goes back to commit c91f6df2db49
("sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface
name") in linux-3.8

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks Nicolas



