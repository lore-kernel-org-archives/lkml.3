Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3L3RTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:19:05 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25199 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051Ab3L3RTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,574,1384297200"; 
   d="scan'208";a="51019963"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: ath9k-devel@venema.h4ckr.net
Cc: kernel-janitors@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        users@rt2x00.serialmonkey.com
Subject: [PATCH 0/11] use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:14:56 +0100
Message-Id: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
used when each argument is an array within a structure that contains at
least two bytes of data beyond the array.

The semantic patch that makes this change is as follows.  To give
moderately good results, this semantic patch requires the spatch options
--recursive-includes and --relax-include-path.  These options make spatch
quite slow.  The results are also very incomplete.  In particular, there is
no result if the structure definition cannot be found or if one of the
arguments is a pointer.  The ocaml code prints some information justifying
the transformation.

// <smpl>
@pre@
expression *e;
position p;
@@

ether_addr_equal@p(...,e,...)

@r@
identifier T;
struct T eth;
identifier fld;
identifier T1;
struct T1 eth1;
identifier fld1;
position p!=pre.p;
@@

ether_addr_equal@p(eth.fld, eth1.fld1)

@ok@
identifier r.T;
type t1, t2;
identifier r.fld, fld2;
position p;
@@

struct T@p { ...
    t1 fld[...];
    t2 fld2;
    ...
  };

@ok1@
identifier r.T1;
type t1, t2;
identifier r.fld1, fld2;
position p1;
@@

struct T1@p1 { ...
    t1 fld1[...];
    t2 fld2;
    ...
  };

@script:ocaml@
rp << r.p;
okp << ok.p;
okp1 << ok1.p1;
t << r.T;
t1 << r.T1;
@@

let rp = List.hd rp in
let okp = List.hd okp in
let okp1 = List.hd okp1 in
Printf.printf "## %s: struct %s defined in %s\n" rp.file t okp.file;
Printf.printf "## %s: struct %s defined in %s\n" rp.file t1 okp1.file;
flush stdout

@depends on ok && ok1@
position r.p;
@@

-ether_addr_equal@p
+ether_addr_equal_64bits
  (...)
// </smpl>
