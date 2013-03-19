Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab3CSCx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:53:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50862 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3CSCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:53:12 -0400
Message-ID: <5147D318.9060400@hitachi.com>
Date: Tue, 19 Mar 2013 11:53:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522> <CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com> <514023AA.4070004@hitachi.com> <847glb8m4i.fsf@sauna.l.org> <51408349.8080800@hitachi.com> <84li9ke88w.fsf@sauna.l.org>
In-Reply-To: <84li9ke88w.fsf@sauna.l.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/19 5:57), Timo Juhani Lindfors wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>> Thank you for reporting!!
> 
> Thanks for fixing these! I spent some time trying to automate the
> process of finding sensitive functions and eventually resorted into
> booting a kvm instance with a minimal initrd to test every single
> function in a clean and reproducible environment.
> 
> I found 7 more cases where calling register_kprobe() leads to an instant
> kernel panic:
> 
> __flush_tlb_single
> native_flush_tlb
> native_safe_halt
> native_set_pgd
> native_set_pmd
> native_set_pud
> native_write_cr0

Ah, right and Great! these native_* things are too fundamental one.
Hmm, curiously, those are defined as inline functions, and
I also couldn't find some of those symbols even with your previous
kconfig.

> You can see full kernel console output for each function at
> http://lindi.iki.fi/lindi/linux/kprobes/panics_2013-03-18/

As you can see, your panic messages, most of them caused GFP.
This may mean that int3 software exception must not happened
on those sites. Not the recursive call.

Perhaps, I'd better add those native_* things into symbol-name
based blacklist, instead of adding __kprobes, because those
are not related to kprobes recursion.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


