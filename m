Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3JHXYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:24:45 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:46699 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3JHXYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:24:44 -0400
Date: Tue, 8 Oct 2013 23:24:41 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linux-kernel@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] math-emu: fix floating-point to integer overflow detection
Message-ID: <Pine.LNX.4.64.1310082323530.23637@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 08 Oct 2013 23:24:44.0114 (UTC) FILETIME=[92152B20:01CEC47D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

On overflow, the math-emu macro _FP_TO_INT_ROUND tries to saturate its
result (subject to the value of rsigned specifying the desired
overflow semantics).  However, if the rounding step has the effect of
increasing the exponent so as to cause overflow (if the rounded result
is 1 larger than the largest positive value with the given number of
bits, allowing for signedness), the overflow does not get detected,
meaning that for unsigned results 0 is produced instead of the maximum
unsigned integer with the give number of bits, without an exception
being raised for overflow, and that for signed results the minimum
(negative) value is produced instead of the maximum (positive) value,
again without an exception.  This patch makes the code check for
rounding increasing the exponent and adjusts the exponent value as
needed for the overflow check.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

This macro is not present in the glibc/libgcc version of the code.
This patch is independent of my separate patch
<http://lkml.org/lkml/2013/10/8/694> to fix the results for unsigned
saturation, although you need both patches together to get the correct
results for the affected unsigned overflow case.  It remains the case
both before and after this patch that the conversions wrongly treat a
signed result of the most negative integer as an overflow, when
actually only that integer minus 1 or smaller should be an overflow,
although this only means an incorrect exception rather than affecting
the value returned; that was one of the bugs I fixed in the
glibc/libgcc version of this code in 2006 (as part of a major overhaul
of the code including various interface changes, so not trivially
backportable to the kernel version).

diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index 9696a5e..6bdf8c6 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -743,12 +743,17 @@ do {									\
 	  }									\
 	else									\
 	  {									\
+	    int _lz0, _lz1;							\
 	    if (X##_e <= -_FP_WORKBITS - 1)					\
 	      _FP_FRAC_SET_##wc(X, _FP_MINFRAC_##wc);				\
 	    else								\
 	      _FP_FRAC_SRS_##wc(X, _FP_FRACBITS_##fs - 1 - X##_e,		\
 				_FP_WFRACBITS_##fs);				\
+	    _FP_FRAC_CLZ_##wc(_lz0, X);						\
 	    _FP_ROUND(wc, X);							\
+	    _FP_FRAC_CLZ_##wc(_lz1, X);						\
+	    if (_lz1 < _lz0)							\
+	      X##_e++; /* For overflow detection.  */				\
 	    _FP_FRAC_SRL_##wc(X, _FP_WORKBITS);					\
 	    _FP_FRAC_ASSEMBLE_##wc(r, X, rsize);				\
 	  }									\

-- 
Joseph S. Myers
joseph@codesourcery.com
