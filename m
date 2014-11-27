Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaK0Kh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:37:59 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60874 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaK0Kh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:37:57 -0500
Date: Thu, 27 Nov 2014 11:41:33 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Converting int usage to bool
Message-ID: <20141127104133.GA5051@wrath>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following semantic patch was used to find
functions and variables declared as int but
used as boolean. The patch resulted in a
significant number of false positive that I
have ignored.

I am not hyper confident about the modification
I made to the functions. Some of them seem to
have quite significant side effects, which is not
necesserarily intended from a boolean function.
In particular both *_rwtest functions write data.
Moreover sisfb_find_host_bridge name may suggest
more than a boolean return.

/* match all explicit boolean functions */
@boolean_function@
identifier fbool;
typedef bool;
@@

bool fbool(...) {
...
}

/* match variables eligible for boolean conversion */
@eligible_var exists@
identifier f, boolean_function.fbool;
local idexpression int x;
identifier xname;
expression e;
position p;
@@

f@p(...) {
...when any
(
  x@xname = 1;
|
  x@xname = 0;
|
  x@xname = (e) ? 0 : 1;
|
  x@xname = (e) ? 1 : 0;
|
  x@xname = fbool(...);
)
...when any
}

/* match all acceptable complex assignement */
@valid_assign exists@
identifier eligible_var.f, boolean_function.fbool;
local idexpression int eligible_var.x;
expression e;
position p;
@@

f(...) {
...when any
(
  x@p = (e) ? 0 : 1;
|
  x@p = (e) ? 1 : 0;
|
  x@p = fbool(...);
)
...when any
}

/* match any expression where x is used as an int */
@badvar1 exists@
identifier eligible_var.f;
local idexpression int eligible_var.x;
expression e1 != {0, 1}, e2;
position p != {valid_assign.p};
@@

f(...) {
...when any
(
  x@p = e1;
|
  x++
|
  ++x
|
  x--
|
  --x
|
  x + e2
|
  x - e2
|
  e2 - x
|
  x & e2
|
  x * e2
|
  x / e2
|
  e2 / x
)
...when any
}

/* match all return statement involving an eligible variable */
@valid_var_return depends on !badvar1 exists@
identifier eligible_var.f;
local idexpression int eligible_var.x;
position p;
@@

f(...) {
...when any
  return x@p;
}

/* match all function eligible for boolean conversion */
/* do not match function returning only boolean variable different from the one considered */
@eligible_func exists@
identifier f;
local idexpression int x;
position valid_var_return.p;
@@

int f(...) {
...when any
(
  return 1;
|
  return 0;
|
  return x@p;
)
}

/* match functions returning something else than a bool */
@badfunc1 exists@
identifier eligible_func.f;
expression e != {0, 1};
position p != valid_var_return.p;
@@

int
f(...) {
...when any
  return e@p;
}

/* satisfied when eligible_var is variable of eligible_func */
@same_function depends on eligible_var exists@
identifier eligible_func.f;
position eligible_var.p;
@@

int
f@p(...) {
...
}

/* match variable being returned as well as other non boolean variable */
@badvar2 depends on badfunc1 && same_function exists@
local idexpression int eligible_var.x;
identifier eligible_func.f;
@@

int
f(...) {
...when any
  return x;
}

@depends on (!eligible_func || eligible_func && !same_function) && !badvar1@
identifier eligible_var.f;
local idexpression int eligible_var.x;
identifier eligible_var.xname;
expression e;
@@


f(...) {
...
(
++ bool xname;
- int xname;
|
++ bool xname = false;
- int xname = 0;
|
++ bool xname = true;
- int xname = 1;
)
<...
(
  x =
- 1;
+ true;
|
  x =
- 0;
+ false;
|
- x = (e) ? 1 : 0;
+ x = (e) ? true : false;
|
- x = (e) ? 0 : 1;
+ x = (e) ? false : true;
)
...>

}

@depends on eligible_func && same_function && !badvar1 && !badvar2@
identifier eligible_func.f;
local idexpression int eligible_var.x;
identifier eligible_var.xname;
expression e;
@@


f(...) {
...
(
++ bool xname;
- int xname;
|
++ bool xname = false;
- int xname = 0;
|
++ bool xname = true;
- int xname = 1;
)
<...
(
  x =
- 1;
+ true;
|
  x =
- 0;
+ false;
|
- x = (e) ? 1 : 0;
+ x = (e) ? true : false;
|
- x = (e) ? 0 : 1;
+ x = (e) ? false : true;
)
...>

}

@depends on !badfunc1@
identifier eligible_func.f;
@@

- int
+ bool
f(...) {
<...
(
- return 1;
+ return true;
|
- return 0;
+ return false;
)
...>
}

Quentin Lambert (1):
  video: fbdev: sis: sis_main.c: converting relevant int to bool

 drivers/video/fbdev/sis/sis_main.c | 64 ++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

-- 
1.9.1

