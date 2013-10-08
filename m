Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3JHXMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:12:32 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45828 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3JHXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:12:31 -0400
Date: Tue, 8 Oct 2013 23:12:27 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linux-kernel@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] math-emu: fix floating-point to integer unsigned saturation
Message-ID: <Pine.LNX.4.64.1310082310120.23637@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 08 Oct 2013 23:12:30.0426 (UTC) FILETIME=[DCC543A0:01CEC47B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

The math-emu macros _FP_TO_INT and _FP_TO_INT_ROUND are supposed to
saturate their results for out-of-range arguments, except in the case
rsigned == 2 (when instead the low bits of the result are taken).
However, in the case rsigned == 0 (converting to unsigned integers),
they mistakenly produce 0 for positive results and the maximum
unsigned integer for negative results, the opposite of correct
unsigned saturation.  This patch fixes the logic.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

I intend to make the corresponding changes to the glibc/libgcc copy of
this code, given that it would be desirable to resync the Linux and
glibc/libgcc copies (the latter has had many enhancements and bug
fixes since it was copied into Linux), although strictly this
incorrect saturation is only a bug when trying to emulate particular
instruction semantics, not when used in userspace to implement C
operations where the results of out-of-range conversions are
unspecified or undefined.

diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index 9696a5e..70fe5e9 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -685,7 +685,7 @@ do {									\
 	    else								\
 	      {									\
 		r = 0;								\
-		if (X##_s)							\
+		if (!X##_s)							\
 		  r = ~r;							\
 	      }									\
 	    FP_SET_EXCEPTION(FP_EX_INVALID);					\
@@ -762,7 +762,7 @@ do {									\
 	    if (!rsigned)							\
 	      {									\
 		r = 0;								\
-		if (X##_s)							\
+		if (!X##_s)							\
 		  r = ~r;							\
 	      }									\
 	    else if (rsigned != 2)						\

-- 
Joseph S. Myers
joseph@codesourcery.com
