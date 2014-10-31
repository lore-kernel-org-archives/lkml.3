Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbaJaRks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:40:48 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:48313 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaJaRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:40:45 -0400
Message-ID: <1414777242.27538.22.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] ipv4: avoid divide 0 error in tcp_incr_quickack
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Chen Weilong <chenweilong@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 10:40:42 -0700
In-Reply-To: <CAADnVQLe+Xs22sbdy7=8KW2+LscFOiFWdKxSFFuPTWSPTHbSow@mail.gmail.com>
References: <1414767047-8972-1-git-send-email-chenweilong@huawei.com>
	 <CAADnVQLe+Xs22sbdy7=8KW2+LscFOiFWdKxSFFuPTWSPTHbSow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 09:24 -0700, Alexei Starovoitov wrote:
> cc-ing netdev
> 
> On Fri, Oct 31, 2014 at 7:50 AM, Chen Weilong <chenweilong@huawei.com> wrote:
> > From: Weilong Chen <chenweilong@huawei.com>
> >
> > We got a problem like this:
> >  [ffff8801c1a05570] machine_kexec at ffffffff81025039
> >  [ffff8801c1a055d0] crash_kexec at ffffffff8109b253
> >  [ffff8801c1a056a0] oops_end at ffffffff81442aed
> >  [ffff8801c1a056d0] die at ffffffff81005603
> >  [ffff8801c1a05700] do_trap at ffffffff81442448
> >  [ffff8801c1a05760] do_divide_error at ffffffff81002c10
> >  [ffff8801c1a05888] tcp_send_dupack at ffffffff81385e44
> >  [ffff8801c1a058c8] tcp_validate_incoming at ffffffff813886b5
> >  [ffff8801c1a05908] tcp_rcv_state_process at ffffffff8138d0b7
> >  [ffff8801c1a05958] tcp_child_process at ffffffff81397255
> >  [ffff8801c1a05988] tcp_v4_do_rcv at ffffffff81395a70
> >  [ffff8801c1a059d8] tcp_v4_rcv at ffffffff81396fc8
> >  [ffff8801c1a05a48] ip_local_deliver_finish at ffffffff813746e9
> >  [ffff8801c1a05a78] ip_local_deliver at ffffffff81374a20
> >  [ffff8801c1a05aa8] ip_rcv_finish at ffffffff81374389
> >  [ffff8801c1a05ad8] ip_rcv at ffffffff81374c78
> > There was a wrong ack packet coming during TCP handshake. The socket's state
> > was TCP_SYN_RECV, its rcv_mss was not initialize yet. So
> > tcp_send_dupack -> tcp_enter_quickack_mode got a divide 0 error.
> > This patch add a state check before tcp_enter_quickack_mode.
> 
> ouch. Is it remote exploitable?

Seems to be SYN crossing. Quite hard, but possible.


