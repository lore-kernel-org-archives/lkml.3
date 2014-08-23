Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaHWLZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21752 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbaHWLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829915"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: dri-devel@lists.freedesktop.org
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH 0/9] use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:22 +0200
Message-Id: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add labels in the initializations of structure fields (c99
initializers).  The complete semantic patch thta makes this change is shown
below.  This rule ignores cases where the initialization is just 0 or NULL,
where some of the fields already use labels, and where there are nested
structures.

// <smpl>
@ok1@
identifier i1,i2;
position p;
@@

struct i1 i2@p = { \(0\|NULL\) };

@ok2@
identifier i1,i2,i3;
position p;
expression e;
@@

struct i1 i2@p = { ..., .i3 = e, ... };

@ok3@
identifier i1,i2;
position p;
@@

struct i1 i2@p = { ..., { ... }, ... };

@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
position p != {ok1.p,ok2.p,ok3.p};
constant nm;
initializer list[decl.n] is;
position fix;
@@

struct i1 i2@p = { is,
(
 nm(...)
|
 e@fix
)
 ,...};

@@
identifier decl.i1,i2,decl.fld;
expression e;
position bad.p, bad.fix;
@@

struct i1 i2@p = { ...,
+ .fld = e
- e@fix
 ,...};
// </smpl>

