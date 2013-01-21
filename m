Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3AUMDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:03:11 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:41316
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab3AUMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187829"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/14] adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:44 +0100
Message-Id: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where a value is tested that was previously
tested.  Often the problem is that the tested value has not been updated
properly.  Sometimes the test is simply duplicated.  These problems were
found using the following semantic match (http://coccinelle.lip6.fr/):

// <smpl>
@r exists@
expression e1,e2;
identifier f,g;
position p1,p2;
@@

if@p1 ( \(e1->f == NULL\|IS_ERR(e1->f)\) ) { ... when forall
   return ...; }
... when != \(e1->f = e2\|e1->f += e2\|e1->f -= e2\|e1->f |= e2\|e1->f &= e2\|e1->f++\|e1->f--\|g(...,e1,...)\)
if@p2 ( \(e1->f == NULL\|IS_ERR(e1->f)\) ) { ... when forall
   return ...; }

@rsame exists@
expression e;
position r.p1,r.p2;
statement S1,S2;
@@

if@p1 ( e ) S1
... when any
if@p2 ( e ) S2

@rok depends on rsame exists@
expression e1,e2;
identifier f;
position r.p1,r.p2;
statement S1,S2;
@@

if@p1 ( \(e1->f == NULL\|IS_ERR(e1->f)\) ) S1
... when any
 \(e1->f = e2\|e1->f += e2\|e1->f -= e2\|e1->f |= e2\|e1->f &= e2\|e1->f++\|e1->f--\|g(...,e1,...)\)
... when any
if@p2 ( ... ) S2

@rother depends on rsame exists@
position r.p1,r.p2;
statement S;
@@

... when != if@p1 (...) S
if@p2 ( ... ) { ... return ...; }

@script:python depends on rsame && !rok && !rother@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].line != p2[0].line):
  cocci.print_main("",p1)
  cocci.print_secs("",p2)

@s exists@
local idexpression y;
expression e;
position p1,p2;
@@


if@p1 ( \(y == NULL\|IS_ERR(y)\|y != 0\) ) { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\|XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
if@p2 ( \(y == NULL\|IS_ERR(y)\|y != 0\) ) { ... when forall
   return ...; }

@ssame exists@
expression e;
position s.p1,s.p2;
statement S1,S2;
@@

if@p1 ( e ) S1
... when any
if@p2 ( e ) S2

@sok depends on ssame exists@
local idexpression y;
expression e;
position s.p1,s.p2;
statement S1,S2;
@@

if@p1 ( \(y == NULL\|IS_ERR(y)\|y != 0\) ) S1
... when any
 \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\|XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
... when any
if@p2 ( ... ) S2

@sother depends on ssame exists@
position s.p1,s.p2;
statement S;
@@

... when != if@p1 (...) S
if@p2 ( ... ) { ... return ...; }

@script:python depends on ssame && !sok && !sother@
p1 << s.p1;
p2 << s.p2;
@@

if (p1[0].line != p2[0].line):
  cocci.print_main("",p1)
  cocci.print_secs("",p2)

// </smpl>

