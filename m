Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287Ab3HHTdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:33:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46531
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966260Ab3HHTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:32:58 -0400
X-IronPort-AV: E=Sophos;i="4.89,841,1367964000"; 
   d="scan'208";a="23548390"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] convert comma to semicolon
Date: Thu,  8 Aug 2013 21:32:51 +0200
Message-Id: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches result from the following semantic patch
(http://coccinelle.lip6.fr/), which checks for expression statements
separated by , rather than by ;.  The rule is quite conservative in that it
only finds cases where this pattern appears after a statement that ends
with ;, to ensure that the expression statements do not form an if branch
or loop body.  Iteration is used to treat arbitrary sequences of commas.

// <smpl>
@initialize:ocaml@

let tbl = Hashtbl.create(100)

let add_if_not_present file =
try let _ = Hashtbl.find tbl file in ()
with Not_found ->
   Hashtbl.add tbl file ();
   let it = new iteration() in
   it#set_files [file];
   it#register()

@script:ocaml@
@@
Hashtbl.clear tbl

@r@
expression e1,e2,e;
position p1,p2;
type T;
identifier i;
@@

(
T i = ...;
|
 e;
)
 e1,@p1 e2@p2;

@script:ocaml@
p1 << r.p1;
p2 << r.p2;
@@

if (List.hd p1).line = (List.hd p2).line
then include_match false
else add_if_not_present ((List.hd p1).file)

@@
expression e1,e2;
position r.p1;
@@

 e1
- ,@p1
+ ;
  e2;
// </smpl>

