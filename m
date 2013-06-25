Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3FYWNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:13:33 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57070 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3FYWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:13:31 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org>
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
	<51C47864.9030200@gmail.com>
	<20130621202244.GA16610@redhat.com>
	<51C4BB86.1020004@caviumnetworks.com>
	<20130622190940.GA14150@redhat.com>
	<51C80CF0.4070608@imgtec.com>
	<20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org>
Date: Tue, 25 Jun 2013 23:13:30 +0100
X-Google-Sender-Auth: Y9pQ2NPq1hJRJdLYCH3Asj4-jTM
Message-ID: <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
From: James Hogan <james.hogan@imgtec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2013 22:40, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 24 Jun 2013 10:10:08 +0100 James Hogan <james.hogan@imgtec.com> wrote:
>
>> On 22/06/13 20:09, Oleg Nesterov wrote:
>> > On 06/21, David Daney wrote:
>> >> I am proposing that we just reduce the number of usable signals such
>> >> that existing libc status checking macros/functions don't change in any
>> >> way.
>> >
>> > And I fully agree! Absolutely, sorry for confusion.
>> >
>> >
>> > What I tried to say, _if_ we change the ABI instead, lets make this
>> > change sane.
>>
>> I agree that this approach isn't very nice (I was really just trying to
>> explore the options) and reducing the number of signals is nicer. But is
>> anybody here confident enough that the number of signals changing under
>> the feet of existing binaries/libc won't actually break anything real?
>> I.e. anything trying to use SIGRTMAX() to get a lower priority signal.
>
> Meanwhile, unprivileged users can make a MIPS kernel go BUG.
>
> How much of a problem is this?  Obviously less of a problem with MIPS
> than it would be with some other CPU types, but I'd imagine it's still
> awkward in some environments.
>
> If this _is_ considered a problem, can we think of some nasty little
> hack which at least makes the effects less damaging, which we can also
> put into -stable kernels?

The first rfc patch I sent sort of satisfies that by passing 127 if
sig==128, or slightly better would be passing 126 if sig>=127 (so that
SIFSIGNALED returns true). Effectively #ifdef'ing it on _NSIG>127 as
this patch does may be preferable too.

That's probably the minimum change necessary to evade the BUG_ON
without removing it. The wait status code will still be wrong, but it
wasn't exactly right before so it's no worse.

IMO changing the ABI by reducing _NSIG to 127 or 126 isn't appropriate
for stable.

Cheers
James
