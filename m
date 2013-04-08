Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab3DHPHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:07:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43237 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965063Ab3DHPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <1365433142.2733.18.camel@fedora>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>
	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	<51624591.4010303@synopsys.com>
	<CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
	<1365428274.2609.160.camel@laptop>
	<1365431470.2733.16.camel@fedora>
	<CA+55aFx88-t_pm5hbxbrrhqm3_=+JQussO=zD1kT+05UVCAFCA@mail.gmail.com>
	<1365433142.2733.18.camel@fedora>
Date: Mon, 8 Apr 2013 08:07:41 -0700
X-Google-Sender-Auth: XbFHBJ1agVDlnefW_uOy7jJHbiQ
Message-ID: <CA+55aFyea-YdNP-=fyV2JMoN2cyv9Vpp3-e4p86V+7OSBQAV5Q@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 7:59 AM, Steven Rostedt <srostedt@redhat.com> wrote:
>>     +/* This is only a barrier to other asms. Notably get_user/put_user */
>
> Probably should add in the comment:
>
>         " or anything else that can cause a hidden schedule. "
>

Fair enough. And I just remembered why I thought UP was special - we
need to do the same thing about spinlocks, for the same reasons.

So that "asm_barrier()" should probably be in <linux/compiler.h> along
with the "normal" barrier() definition.

*AND* somebody should re-check the gcc documentation on "volatile
asm". I'm pretty sure it used to say "not moved significantly,
including against each other" or something like that, but the gcc asm
docs have changed over time.

I'd hate to have to add a memory clobber to the get_user/put_user
asms, because that would *really* hurt. But maybe we could add some
other clobber ("cc" or similar) to make sure they can't be re-ordered
if the "volatile" isn't sufficient to make sure asms don't get
re-ordered wrt each other.

                Linus
