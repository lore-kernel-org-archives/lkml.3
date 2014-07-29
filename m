Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaG2PX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:23:57 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57251 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbaG2PT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:19:56 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459210"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        linux-gpio@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        e1000-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 0/9] use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:42 +0200
Message-Id: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix typos in the name of a type referenced in a sizeof
command.  These problems are not caught by the compiler, because they have
no impact on execution - the size of a pointer is independent of the size
of the pointed value.

The semantic patch that finds these problems is shown below
(http://coccinelle.lip6.fr/).  This semantic patch distinguishes between
structures that are defined in C files, and thus are expected to be visible
in only that file, and structures that are defined in header files, which
could potential be visible everywhere.  This distinction seems to be
unnecessary in practice, though.

<smpl>
virtual after_start

@initialize:ocaml@
@@

type fl = C of string | H

let structures = Hashtbl.create 101
let restarted = ref false

let add_if_not_present _ =
  if not !restarted
  then
    begin
      restarted := true;
      let it = new iteration() in
      it#add_virtual_rule After_start;
      it#register()
    end

let hashadd str file =
  let cell =
    try Hashtbl.find structures str
    with Not_found ->
      let cell = ref [] in
      Hashtbl.add structures str cell;
      cell in
  if not (List.mem file !cell) then cell := file :: !cell

let get_file fl =
  if Filename.check_suffix fl ".c"
  then C fl
  else H

@script:ocaml depends on !after_start@
@@
add_if_not_present()

@r depends on !after_start@
identifier nm;
position p;
@@

struct nm@p { ... };

@script:ocaml@
nm << r.nm;
p << r.p;
@@

hashadd nm (get_file (List.hd p).file)

// -------------------------------------------------------------------------

@sz depends on after_start@
identifier nm;
position p;
@@

sizeof(struct nm@p *)

@script:ocaml@
nm << sz.nm;
p << sz.p;
@@

try
  let allowed = !(Hashtbl.find structures nm) in
  if List.mem H allowed or List.mem (get_file (List.hd p).file) allowed
  then ()
  else print_main nm p
with Not_found -> print_main nm p
</smpl>

