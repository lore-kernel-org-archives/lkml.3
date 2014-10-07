Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaJGILC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:11:02 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60298 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbaJGIKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:10:45 -0400
Message-ID: <1412669443.18874.16.camel@x220>
Subject: Re: [PATCH v2 1/2] kconfig: fix bad syntactic transformation in
 expr.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 10:10:43 +0200
In-Reply-To: <1411405999-20212-2-git-send-email-walch.martin@web.de>
References: <3491939.FtiyjGE4Of@tacticalops>
	 <1411405999-20212-1-git-send-email-walch.martin@web.de>
	 <1411405999-20212-2-git-send-email-walch.martin@web.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2014 08:10:43.0876 (UTC) FILETIME=[311DEE40:01CFE206]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 19:13 +0200, Martin Walch wrote:
> expr_eliminate_dups2() in scripts/kconfig/expr.c applies two bad
> inference rules:
> 
> (FOO || BAR) && (!FOO && !BAR) -> n
> (FOO && BAR) || (!FOO || !BAR) -> y
> 
> They would be correct in propositional logic, but this is a three-valued
> logic, and here it is wrong in that it changes semantics. It becomes
> immediately visible when substituting FOO and BAR with m.

Well, not to me. When I apply the rules under "Menu dependencies" in
Documentation/kbuild/kconfig-language.txt, in embarrassingly small
steps, I get:
    (m || m) && (!m && !m) ->
    (1 || 1) && ((2 - 1) && (2 - 1)) ->
    (1 || 1) && (1 && 1) ->
    max(1, 1) && min(1, 1) ->
    1 && 1 ->
    min(1, 1) ->
    1 -> m

and
    (m && m) || (!m || !m) ->
    (1 && 1) || ((2 - 1) || (2 - 1)) ->
    (1 && 1) || (1 || 1) ->
    min(1, 1) || max(1, 1) ->
    1 || 1 ->
    max(1, 1) ->
    1 -> m

Did I do that right? Anyway, perhaps you'd like to add a line or two how
these two expressions actually evaluate when FOO and BAR are m.

> Fix it by removing expr_eliminate_dups2() and the functions that have no use
> anywhere else: expr_extract_eq_and(), expr_extract_eq_or(),
> and expr_extract_eq() from scripts/kconfig/expr.[ch]
> 
> Currently the bug is not triggered in mainline, so this patch does not modify
> the configuration space there.
> 
> As a side effect, this reduces code size in expr.c by roughly 10% and slightly
> improves startup time for all configuration frontends.
> 
> Signed-off-by: Martin Walch <walch.martin@web.de>

Does Yann still care about Kconfig? Yann has been rather quiet for a
while now.


Paul Bolle

