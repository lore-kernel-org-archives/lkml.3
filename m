Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaG2AMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:12:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34753 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaG2AMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:12:15 -0400
Date: Mon, 28 Jul 2014 17:12:13 -0700 (PDT)
Message-Id: <20140728.171213.1219772609929469928.davem@davemloft.net>
To: pablo@netfilter.org
Cc: ast@plumgrid.com, dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemb@google.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: filter: rename 'struct sk_filter' to
 'struct bpf_prog'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140728214552.GA4049@salvia>
References: <20140725221512.GA3729@salvia>
	<CAMEtUux8F4xZ77_HQADfoeV-9sibaEWm=XJcAaY+cQyDWb2caA@mail.gmail.com>
	<20140728214552.GA4049@salvia>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Jul 2014 17:12:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 28 Jul 2014 23:45:52 +0200

> By renaming this, you're not fixing up things the semantics. It seems
> to me you just want to find a quick path to solve inconsistencies in
> your code.

Agreed, this looks just like messing around with naming to me.

But to the original issue, that of xt_bpf, I wonder about a few things:

1) If we have a kernel pointer embedded in a user provided datastructure,
   what takes care of 32-bit compat applications uploading xt_bpf rules
   on a 64-bit kernel?  Won't the size be wrong or does it not matter
   and is in some way helped by that 8-byte alignment thing there?

2) The user can't care about the type of "filter" in xt_bpf_info, so
   we can use whatever name we want for the type.

   Therefore you can just do something like:


struct bpf_prog;

struct xt_bpf_info {
	__u16 bpf_program_num_elem;
	struct sock_filter bpf_program[XT_BPF_MAX_NUM_INSTR];

	/* only used in the kernel */
	struct bpf_prog *filter __attribute__((aligned(8)));
};

   and then you won't need any casting.
