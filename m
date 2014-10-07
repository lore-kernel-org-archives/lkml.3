Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaJGJXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:23:36 -0400
Received: from services.gouders.net ([141.101.32.176]:55561 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJGJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:23:06 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Walch <walch.martin@web.de>, yann.morin.1998@free.fr,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kconfig: fix bad syntactic transformation in expr.c
In-Reply-To: <1412669443.18874.16.camel@x220> (Paul Bolle's message of "Tue,
	07 Oct 2014 10:10:43 +0200")
References: <3491939.FtiyjGE4Of@tacticalops>
	<1411405999-20212-1-git-send-email-walch.martin@web.de>
	<1411405999-20212-2-git-send-email-walch.martin@web.de>
	<1412669443.18874.16.camel@x220>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Tue, 07 Oct 2014 11:21:51 +0200
Message-ID: <ghzjd8tets.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Michal added

Paul Bolle <pebolle@tiscali.nl> writes:

> On Mon, 2014-09-22 at 19:13 +0200, Martin Walch wrote:
>> expr_eliminate_dups2() in scripts/kconfig/expr.c applies two bad
>> inference rules:
>> 
>> (FOO || BAR) && (!FOO && !BAR) -> n
>> (FOO && BAR) || (!FOO || !BAR) -> y
>> 
>> They would be correct in propositional logic, but this is a three-valued
>> logic, and here it is wrong in that it changes semantics. It becomes
>> immediately visible when substituting FOO and BAR with m.
>
> Well, not to me. When I apply the rules under "Menu dependencies" in
> Documentation/kbuild/kconfig-language.txt, in embarrassingly small
> steps, I get:
>     (m || m) && (!m && !m) ->
>     (1 || 1) && ((2 - 1) && (2 - 1)) ->
>     (1 || 1) && (1 && 1) ->
>     max(1, 1) && min(1, 1) ->
>     1 && 1 ->
>     min(1, 1) ->
>     1 -> m
>
> and
>     (m && m) || (!m || !m) ->
>     (1 && 1) || ((2 - 1) || (2 - 1)) ->
>     (1 && 1) || (1 || 1) ->
>     min(1, 1) || max(1, 1) ->
>     1 || 1 ->
>     max(1, 1) ->
>     1 -> m
>
> Did I do that right? Anyway, perhaps you'd like to add a line or two how
> these two expressions actually evaluate when FOO and BAR are m.

Perhaps, it helps to use a Kconfig file that visualizes the problem:

mainmenu "Expr Test"

config expr-config
	bool "Expr Config"
	depends on (m || m) && (!m && !m)
#	depends on (m && m) || (!m || !m)

config dummy
       bool "Dummy"

config modules
       bool
       option modules
       default y

Those two depends, according to your calculation and if I understood
correctly also to Martin's, should evaluate to 'm' and thus the menu
entry should always be visible, because both depends should evaluate to
'm'.  But because of expr_eliminate_dups2() it is either invisible (the
first depends becomes 'n') or always visible (the second depends becomes
'y').

Dirk

>> Fix it by removing expr_eliminate_dups2() and the functions that have no use
>> anywhere else: expr_extract_eq_and(), expr_extract_eq_or(),
>> and expr_extract_eq() from scripts/kconfig/expr.[ch]
>> 
>> Currently the bug is not triggered in mainline, so this patch does not modify
>> the configuration space there.
>> 
>> As a side effect, this reduces code size in expr.c by roughly 10% and slightly
>> improves startup time for all configuration frontends.
>> 
>> Signed-off-by: Martin Walch <walch.martin@web.de>
>
> Does Yann still care about Kconfig? Yann has been rather quiet for a
> while now.
>
>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
