Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbaGYODm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:03:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64345 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760300AbaGYODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:03:40 -0400
Date: Fri, 25 Jul 2014 10:02:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@kernel.org>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725140237.GB32669@home.goodmis.org>
References: <20140723182518.GD3935@laptop>
 <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
 <20140723184111.GG3935@laptop>
 <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
 <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
 <20140725035527.GA30108@pg-vmw-gw1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725035527.GA30108@pg-vmw-gw1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:55:28PM -0700, Alexei Starovoitov wrote:
> 
> -mno-red-zone only affected prologue emition in gcc. This part didn't
> change between the releases. So the bug is quite deep.
> What seems to be happening is that 2nd pass of instruction scheduler
> (after emit prologue and reg alloc) is ignoring barrier properties
> of 'subq $184, %rsp' and moving 'movq $.., -136(%rbp)' instruction
> ahead of it. afaik rtl sched was never aware of 'red-zone'.
> As an ex-compiler guy, I'm worried that this bug exists in earlier
> releases. rtl backend guys need to take a serious look at it.
> imo this is very serious bug, since broken red-zone is extremelly
> hard to debug.

But wouldn't it be rather trivial to run a static analyzer on the final
vmlinux to make sure there are no red zones? I mean, you would only need
to read each function and check to make sure that the offset of rbp is
within the change of rsp, wouldn't you?

Almost seems like an objdump -rd into a perl script could do this.

-- Steve


> There are two weak test in gcc testsuite related to -mno-red-zone,
> but not a single test that actually check that it is doing
> the right thing. It is scary. I hope I'm wrong with this analysis.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
