Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKXIiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:38:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38532 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaKXIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:38:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141123233637.GC12456@thin>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
	<20141123.134623.2061031332250984539.davem@davemloft.net>
	<20141123194326.GB8517@thin>
	<20141123203040.GB26749@smipidev>
	<20141123233637.GC12456@thin>
Date: Mon, 24 Nov 2014 09:38:20 +0100
X-Google-Sender-Auth: peioOhpX1wWVlyXatAAORO_v8CI
Message-ID: <CAMuHMdW8gAiyFiPHu-N4Dg_+b6Qg9JXZZ3PqOn=VmZLcEH-Xkg@mail.gmail.com>
Subject: Re: [PATCH 0/6] kernel tinification: optionally compile out splice
 family of syscalls (splice, vmsplice, tee and sendfile)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Pieter Smith <pieter@boesman.nl>, David Miller <davem@davemloft.net>,
        alexander.h.duyck@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>, beber@meleeweb.net,
        catalina.mocanu@gmail.com, Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fabian Frederick <fabf@skynet.be>, fuse-devel@lists.sourceforge.net,
        Hugh Dickins <hughd@google.com>, iulia.manda21@gmail.com,
        Jan Beulich <JBeulich@suse.com>, bfields@fieldses.org,
        jlayton@poochiereds.net, linux-api@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Matt Turner <mattst88@gmail.com>, Mel Gorman <mgorman@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul.Durrant@citrix.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Foley <pefoley2@pefoley.com>, Thomas Graf <tgraf@suug.ch>,
        Tom Herbert <therbert@google.com>, willemb@google.com,
        xiaoguangrong@linux.vnet.ibm.com, zhenglong.cai@cs2c.com.cn
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:36 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Sun, Nov 23, 2014 at 09:30:40PM +0100, Pieter Smith wrote:
>> On Sun, Nov 23, 2014 at 11:43:26AM -0800, Josh Triplett wrote:
>> > On Sun, Nov 23, 2014 at 01:46:23PM -0500, David Miller wrote:
>> > > Truly removing sendfile/sendpage means that you can't even compile NFS
>> > > into the tree.
>> >
>> > If you mean the in-kernel nfsd (CONFIG_NFSD), that already has a large
>> > stack of "select" and "depends on", both directly and indirectly; adding
>> > a "select SPLICE_SYSCALL" to it seems fine.  (That select does need
>> > adding, though.  Pieter, you need to test-compile more than just
>> > tinyconfig and defconfig.  Try an allyesconfig with *just* splice turned
>> > off, and make sure that compiles.)
>>
>> Did exacly that. Took forever on my hardware, but no problems.
>
> Ah, I see.  Looking more closely at nfsd, it looks like it already has a
> code path for filesystems that don't do splice.  I think, rather than
> making nfsd select SPLICE_SYSCALL, that it would suffice to change the
> "rqstp->rq_splice_ok = true;" in svc_process_common (net/sunrpc/svc.c)
> to:
>
> rqstp->rq_splice_ok = IS_ENABLED(CONFIG_SPLICE_SYSCALL);
>
> Then nfsd should simply *always* fall back to its non-splice support.

Hence I suggest adding to the nfsd help text:

    While nfsd works without SPLICE_SYSCALL, you may want to enable
    SPLICE_SYSCALL for <...> (performance?) reasons.

(Hmm, does Kconfig need a "suggests", cfr. Debian package dependencies?)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
