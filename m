Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaIETG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:06:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaIETDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:03:11 -0400
Date: Fri, 05 Sep 2014 12:03:09 -0700 (PDT)
Message-Id: <20140905.120309.442605076285121829.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spender@grsecurity.net, dborkman@redhat.com, ast@plumgrid.com,
        keescook@chromium.org
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images
 read-only
From: David Miller <davem@davemloft.net>
In-Reply-To: <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org>
	<2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 12:03:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Tue,  2 Sep 2014 22:53:44 +0200

> From: Daniel Borkmann <dborkman@redhat.com>
> 
> With eBPF getting more extended and exposure to user space is on it's way,
> hardening the memory range the interpreter uses to steer its command flow
> seems appropriate.  This patch moves the to be interpreted bytecode to
> read-only pages.
> 
> In case we execute a corrupted BPF interpreter image for some reason e.g.
> caused by an attacker which got past a verifier stage, it would not only
> provide arbitrary read/write memory access but arbitrary function calls
> as well. After setting up the BPF interpreter image, its contents do not
> change until destruction time, thus we can setup the image on immutable
> made pages in order to mitigate modifications to that code. The idea
> is derived from commit 314beb9bcabf ("x86: bpf_jit_comp: secure bpf jit
> against spraying attacks").
> 
> This is possible because bpf_prog is not part of sk_filter anymore.
> After setup bpf_prog cannot be altered during its life-time. This prevents
> any modifications to the entire bpf_prog structure (incl. function/JIT
> image pointer).
> 
> Every eBPF program (including classic BPF that are migrated) have to call
> bpf_prog_select_runtime() to select either interpreter or a JIT image
> as a last setup step, and they all are being freed via bpf_prog_free(),
> including non-JIT. Therefore, we can easily integrate this into the
> eBPF life-time, plus since we directly allocate a bpf_prog, we have no
> performance penalty.
> 
> Tested with seccomp and test_bpf testsuite in JIT/non-JIT mode and manual
> inspection of kernel_page_tables.  Brad Spengler proposed the same idea
> via Twitter during development of this patch.
> 
> Joint work with Hannes Frederic Sowa.
> 
> Suggested-by: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied, thanks.
