Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJKAVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:21:18 -0400
Received: from mout.web.de ([212.227.17.11]:62992 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbaJKAVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:21:16 -0400
From: Martin Walch <walch.martin@web.de>
To: Dirk Gouders <dirk@gouders.net>
Cc: Paul Bolle <pebolle@tiscali.nl>, Martin Walch <walch.martin@web.de>,
        yann.morin.1998@free.fr, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kconfig: fix bad syntactic transformation in expr.c
Date: Sat, 11 Oct 2014 02:20:49 +0200
Message-ID: <4216589.44AETaAugF@tacticalops>
User-Agent: KMail/4.14.1 (Linux/3.15.10-gentoo-gnu; KDE/4.14.1; x86_64; ; )
In-Reply-To: <ghzjd8tets.fsf@lena.gouders.net>
References: <3491939.FtiyjGE4Of@tacticalops> <1412669443.18874.16.camel@x220> <ghzjd8tets.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:XwKJ6fHzL5Cm1EZ3KPtDGt19ArDCh3Yg91YLwiu/Z6M6MHQpbe+
 afAh1pYr5QmsgCoIguaTR0M5WYPB0whFJxtQzniwTi9SF4gJxLZeUZALLCCjWWLanPgu6Ya
 w3zODGuoiOrVCZEgRa3zoBmBYRQgzNbAgIb2jGI8SbWXvCN7iQjIM65D9Lp7An7bCiV9Nns
 1Wq/8D3l+5Oacsp9Cfq4Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 11:21:51 Dirk Gouders wrote:
> Paul Bolle <pebolle@tiscali.nl> writes:
> 
> > On Mon, 2014-09-22 at 19:13 +0200, Martin Walch wrote:
> >> expr_eliminate_dups2() in scripts/kconfig/expr.c applies two bad
> >> inference rules:
> >> 
> >> (FOO || BAR) && (!FOO && !BAR) -> n
> >> (FOO && BAR) || (!FOO || !BAR) -> y
> >> 
> >> They would be correct in propositional logic, but this is a three-valued
> >> logic, and here it is wrong in that it changes semantics. It becomes
> >> immediately visible when substituting FOO and BAR with m.
> >
> > Well, not to me. When I apply the rules under "Menu dependencies" in
> > Documentation/kbuild/kconfig-language.txt, in embarrassingly small
> > steps, I get:
> >     (m || m) && (!m && !m) ->
> >     (1 || 1) && ((2 - 1) && (2 - 1)) ->
> >     (1 || 1) && (1 && 1) ->
> >     max(1, 1) && min(1, 1) ->
> >     1 && 1 ->
> >     min(1, 1) ->
> >     1 -> m
> >
> > and
> >     (m && m) || (!m || !m) ->
> >     (1 && 1) || ((2 - 1) || (2 - 1)) ->
> >     (1 && 1) || (1 || 1) ->
> >     min(1, 1) || max(1, 1) ->
> >     1 || 1 ->
> >     max(1, 1) ->
> >     1 -> m
> >
> > Did I do that right? Anyway, perhaps you'd like to add a line or two how
> > these two expressions actually evaluate when FOO and BAR are m.

Yes, this is a proper evaluation.

To explain the problem in more detail, I will describe it a bit more formal.
First of all, this is a thing about the formal system of the configuration
logic, so I think it is a good idea to distinguish between syntax and
semantics.

Any expression, e.g. "(FOO || BAR)" is pure syntax. It consists of
non-constant symbols (FOO, BAR...), constant symbols (n, m, y),
operators (||, &&, !), and parenthesis.

Semantics is when evaluating an expression by assigning values to the
constant and the non-constant symbols and functions to the operators
(overriding operator precedence with parenthesis), and then calculating
an actual value.

So, this is pure syntax: 
(FOO || BAR) && (!FOO && !BAR)

And semantics is:
* an assignment of 0, 1, or 2 to each of the non-constant symbols (arbitrary)
* the fixed assignments of 0 to n, 1 to m, and 2 to y
* applying the functions to values that correspond to the respective operators

So, e.g. when assigning 2 to FOO and 0 to BAR, then the evaluation of 

(FOO || BAR) && (!FOO && !BAR)

is 

min(max(2, 0), min(2-2, 2-0)) = 0

Above, we saw that assigning 1 to FOO as well as to BAR yields 1 for the
whole expression.

Now getting back to the problem: the configuration system makes some
syntactical transformations according to some rules, so they are easier to
read in the user interfaces (e.g. mconf). In formal logic, such rules are
called "inference rules". Obviously, inference rules are purely syntactical
transformations, e.g. one rule could be to replace "FOO && FOO" with only
"FOO". Another rule could replace "FOO || BAR" with "FOO && BAR". The
difference between these two example rules is that in semantics, the first
one keeps the result of the evaluation for all possible assignments, while
the second one changes the results for some of the assignments. Formally,
the first rule is "valid" while the second one is not.

With the term "valid" it is now easy to summarize the actual problem:

The inference rule

(FOO || BAR) && (!FOO && !BAR) -> n

is not valid. The proof for this is assigning 1 to FOO and also to BAR.
As we have already seen, for this assignment, the expression evaluates to 1.
In contrast, the expression "n" always evaluates to 0. So, this inference
rule is not valid.

> Perhaps, it helps to use a Kconfig file that visualizes the problem:
> 
> mainmenu "Expr Test"
> 
> config expr-config
> 	bool "Expr Config"
> 	depends on (m || m) && (!m && !m)
> #	depends on (m && m) || (!m || !m)
> 
> config dummy
>        bool "Dummy"
> 
> config modules
>        bool
>        option modules
>        default y
> 
> Those two depends, according to your calculation and if I understood
> correctly also to Martin's, should evaluate to 'm' and thus the menu
> entry should always be visible, because both depends should evaluate to
> 'm'.  But because of expr_eliminate_dups2() it is either invisible (the
> first depends becomes 'n') or always visible (the second depends becomes
> 'y').

This is a good idea. However, I tried to avoid an example that contains
the constant symbol "m". The problem with this is that "m" is treated
specially and can lead to some confusion, although a very short test case is
possible using m:

config expr-config-short
	bool "Expr Config Short"
	depends on m && !m

When this file is read, each of the two "m" symbols is replaced with
"m && MODULES", so the expression reads:

(m && MODULES) && !(m && MODULES)

then the negation of "!(m && MODULES)" is transformed:

(m && MODULES) && (!m || !MODULES)
(this corresponds to one of the "De Morgan's laws" in other logical systems)

Finally, the bad inference rule applies (although the form of the expression is
slightly different from above) and this expression is replaced with:

n

This is not valid (assigning 2 to MODULES should yield 1 for the whole
expression, but "n" evaluates to 0).

Does this make things clearer?

Regards,
Martin Walch
-- 

