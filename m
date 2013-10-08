Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3JHXnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:43:24 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48044 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3JHXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:43:20 -0400
Date: Tue, 8 Oct 2013 23:43:15 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Shan Hai <shan.hai@windriver.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: fix e500 SPE float to integer and fixed-point
 conversions
In-Reply-To: <Pine.LNX.4.64.1310082337080.23637@digraph.polyomino.org.uk>
Message-ID: <Pine.LNX.4.64.1310082342160.23637@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1310082337080.23637@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 08 Oct 2013 23:43:19.0232 (UTC) FILETIME=[2ABEAC00:01CEC480]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Oct 2013, Joseph S. Myers wrote:

> I'll send as a followup the testcase I used for verifying that the
> instructions (other than the theoretical conversions to 64-bit
> integers) produce the correct results.  In addition, this has been
> tested with the glibc testsuite (with the e500 port as posted at
> <https://sourceware.org/ml/libc-alpha/2013-10/msg00195.html>, where it
> improves the libm test results.

Here is that testcase.

#include <stdio.h>
#include <stdlib.h>

#define INFF __builtin_inff ()
#define INFD __builtin_inf ()
#define NANF __builtin_nanf ("")
#define NAND __builtin_nan ("")

/* e500 rounding modes: 0 = nearest, 1 = zero, 2 = up, 3 = down.  */

static inline void
set_rm (unsigned int mode)
{
  unsigned int spefscr;
  asm volatile ("mfspefscr %0" : "=r" (spefscr));
  spefscr = (spefscr & ~3) | mode;
  asm volatile ("mtspefscr %0" : : "r" (spefscr));
}

static int success_count, failure_count;

struct float_test_data
{
  float input;
  unsigned int expected[4];
};

struct double_test_data
{
  double input;
  unsigned int expected[4];
};

typedef float vfloat __attribute__ ((vector_size (8)));
typedef unsigned int vuint __attribute__ ((vector_size (8)));

union vfloat_union
{
  vfloat vf;
  float f[2];
};

union vuint_union
{
  vuint vui;
  unsigned int ui[2];
};

#define T(A, B, C, D, E) { (A), { (B), (C), (D), (E) } }
#define TZ(A, B) T (A, B, B, B, B)

static void
check_result (const char *insn, double input, unsigned int rm,
	      unsigned int expected, unsigned int res)
{
  if (res == expected)
    success_count++;
  else
    {
      failure_count++;
      printf ("%s %a mode %u expected 0x%x (%d) got 0x%x (%d)\n",
	      insn, input, rm, expected, (int) expected, res, (int) res);
    }
}

#define RUN_FLOAT_TESTS(INSN)						\
static void								\
test_##INSN (void)							\
{									\
  size_t i;								\
  for (i = 0;								\
       i < sizeof (INSN##_test_data) / sizeof (INSN##_test_data[0]);	\
       i++)								\
    {									\
      unsigned int rm;							\
      for (rm = 0; rm <= 3; rm++)					\
	{								\
	  set_rm (rm);							\
	  unsigned int res;						\
	  asm volatile (#INSN " %0, %1"					\
			: "=&r" (res)					\
			: "r" (INSN##_test_data[i].input));		\
	  check_result (#INSN, INSN##_test_data[i].input, rm,		\
			INSN##_test_data[i].expected[rm], res);		\
	}								\
    }									\
}

#define RUN_VFLOAT_TESTS(INSN, TINSN)					\
static void								\
test_##INSN (void)							\
{									\
  size_t i;								\
  for (i = 0;								\
       i < sizeof (TINSN##_test_data) / sizeof (TINSN##_test_data[0]);	\
       i++)								\
    {									\
      unsigned int rm;							\
      for (rm = 0; rm <= 3; rm++)					\
	{								\
	  set_rm (rm);							\
	  union vfloat_union varg;					\
	  union vuint_union vres;					\
	  varg.f[0] = TINSN##_test_data[i].input;			\
	  varg.f[1] = 0;						\
	  asm volatile (#INSN " %0, %1"					\
			: "=&r" (vres.vui)				\
			: "r" (varg.vf));				\
	  check_result (#INSN " (high)", TINSN##_test_data[i].input,	\
			rm, TINSN##_test_data[i].expected[rm],		\
			vres.ui[0]);					\
	  check_result (#INSN " (low 0)", TINSN##_test_data[i].input,	\
			rm, 0, vres.ui[1]);				\
	  varg.f[1] = TINSN##_test_data[i].input;			\
	  varg.f[0] = 0;						\
	  asm volatile (#INSN " %0, %1"					\
			: "=&r" (vres.vui)				\
			: "r" (varg.vf));				\
	  check_result (#INSN " (low)", TINSN##_test_data[i].input,	\
			rm, TINSN##_test_data[i].expected[rm],		\
			vres.ui[1]);					\
	  check_result (#INSN " (high 0)", TINSN##_test_data[i].input,	\
			rm, 0, vres.ui[0]);				\
	}								\
    }									\
}

static const struct float_test_data efsctsiz_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0x7fffffff),
    TZ (0x1.fffffep127f, 0x7fffffff),
    TZ (0x1p31f, 0x7fffffff),
    TZ (0x1.fffffep30f, 0x7fffff80),
    TZ (1.6f, 1),
    TZ (1.5f, 1),
    TZ (1.4f, 1),
    TZ (1.0f, 1),
    TZ (0.6f, 0),
    TZ (0.5f, 0),
    TZ (0.4f, 0),
    TZ (0x1p-149f, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    TZ (-0x1p-149f, 0),
    TZ (-0.4f, 0),
    TZ (-0.5f, 0),
    TZ (-0.6f, 0),
    TZ (-1.0f, -1),
    TZ (-1.4f, -1),
    TZ (-1.5f, -1),
    TZ (-1.6f, -1),
    TZ (-0x1.fffffep30f, 0x80000080),
    TZ (-0x1p31f, 0x80000000),
    TZ (-0x1.fffffep127f, 0x80000000),
    TZ (-INFF, 0x80000000),
    TZ (-NANF, 0),
  };

static const struct float_test_data efsctuiz_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0xffffffff),
    TZ (0x1.fffffep127f, 0xffffffff),
    TZ (0x1p32f, 0xffffffff),
    TZ (0x1.fffffep31f, 0xffffff00),
    TZ (1.6f, 1),
    TZ (1.5f, 1),
    TZ (1.4f, 1),
    TZ (1.0f, 1),
    TZ (0.6f, 0),
    TZ (0.5f, 0),
    TZ (0.4f, 0),
    TZ (0x1p-149f, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    TZ (-0x1p-149f, 0),
    TZ (-0.4f, 0),
    TZ (-0.5f, 0),
    TZ (-0.6f, 0),
    TZ (-1.0f, 0),
    TZ (-1.4f, 0),
    TZ (-1.5f, 0),
    TZ (-1.6f, 0),
    TZ (-0x1.fffffep127f, 0),
    TZ (-INFF, 0),
    TZ (-NANF, 0),
  };

static const struct double_test_data efdctsiz_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0x7fffffff),
    TZ (0x1.fffffffffffffp1023, 0x7fffffff),
    TZ (0x1.0000000000001p31, 0x7fffffff),
    TZ (0x1p31, 0x7fffffff),
    TZ (0x1.fffffffffffffp30, 0x7fffffff),
    TZ (0x1.fffffffcp30, 0x7fffffff),
    TZ (1.6, 1),
    TZ (1.5, 1),
    TZ (1.4, 1),
    TZ (1.0, 1),
    TZ (0.6, 0),
    TZ (0.5, 0),
    TZ (0.4, 0),
    TZ (0x1p-1074, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    TZ (-0x1p-1074, 0),
    TZ (-0.4, 0),
    TZ (-0.5, 0),
    TZ (-0.6, 0),
    TZ (-1.0, -1),
    TZ (-1.4, -1),
    TZ (-1.5, -1),
    TZ (-1.6, -1),
    TZ (-0x1.fffffffcp30, 0x80000001),
    TZ (-0x1.fffffffffffffp30, 0x80000001),
    TZ (-0x1p31, 0x80000000),
    TZ (-0x1.0000000000001p31, 0x80000000),
    TZ (-0x1.fffffffffffffp1023, 0x80000000),
    TZ (-INFD, 0x80000000),
    TZ (-NAND, 0),
  };

static const struct double_test_data efdctuiz_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0xffffffff),
    TZ (0x1.fffffffffffffp1023, 0xffffffff),
    TZ (0x1.0000000000001p32, 0xffffffff),
    TZ (0x1p32, 0xffffffff),
    TZ (0x1.fffffffffffffp31, 0xffffffff),
    TZ (1.6, 1),
    TZ (1.5, 1),
    TZ (1.4, 1),
    TZ (1.0, 1),
    TZ (0.6, 0),
    TZ (0.5, 0),
    TZ (0.4, 0),
    TZ (0x1p-1074, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    TZ (-0x1p-1074, 0),
    TZ (-0.4, 0),
    TZ (-0.5, 0),
    TZ (-0.6, 0),
    TZ (-1.0, 0),
    TZ (-1.4, 0),
    TZ (-1.5, 0),
    TZ (-1.6, 0),
    TZ (-0x1.fffffffffffffp1023, 0),
    TZ (-INFD, 0),
    TZ (-NAND, 0),
  };

static const struct float_test_data efsctsi_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0x7fffffff),
    TZ (0x1.fffffep127f, 0x7fffffff),
    TZ (0x1p31f, 0x7fffffff),
    TZ (0x1.fffffep30f, 0x7fffff80),
    T (1.6f, 2, 1, 2, 1),
    T (1.5f, 2, 1, 2, 1),
    T (1.4f, 1, 1, 2, 1),
    TZ (1.0f, 1),
    T (0.6f, 1, 0, 1, 0),
    T (0.5f, 0, 0, 1, 0),
    T (0.4f, 0, 0, 1, 0),
    T (0x1p-149f, 0, 0, 1, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    T (-0x1p-149f, 0, 0, 0, -1),
    T (-0.4f, 0, 0, 0, -1),
    T (-0.5f, 0, 0, 0, -1),
    T (-0.6f, -1, 0, 0, -1),
    TZ (-1.0f, -1),
    T (-1.4f, -1, -1, -1, -2),
    T (-1.5f, -2, -1, -1, -2),
    T (-1.6f, -2, -1, -1, -2),
    TZ (-0x1.fffffep30f, 0x80000080),
    TZ (-0x1p31f, 0x80000000),
    TZ (-0x1.fffffep127f, 0x80000000),
    TZ (-INFF, 0x80000000),
    TZ (-NANF, 0),
  };

static const struct float_test_data efsctui_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0xffffffff),
    TZ (0x1.fffffep127f, 0xffffffff),
    TZ (0x1p32f, 0xffffffff),
    TZ (0x1.fffffep31f, 0xffffff00),
    T (1.6f, 2, 1, 2, 1),
    T (1.5f, 2, 1, 2, 1),
    T (1.4f, 1, 1, 2, 1),
    TZ (1.0f, 1),
    T (0.6f, 1, 0, 1, 0),
    T (0.5f, 0, 0, 1, 0),
    T (0.4f, 0, 0, 1, 0),
    T (0x1p-149f, 0, 0, 1, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    TZ (-0x1p-149f, 0),
    TZ (-0.4f, 0),
    TZ (-0.5f, 0),
    TZ (-0.6f, 0),
    TZ (-1.0f, 0),
    TZ (-1.4f, 0),
    TZ (-1.5f, 0),
    TZ (-1.6f, 0),
    TZ (-0x1.fffffep127f, 0),
    TZ (-INFF, 0),
    TZ (-NANF, 0),
  };

static const struct double_test_data efdctsi_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0x7fffffff),
    TZ (0x1.fffffffffffffp1023, 0x7fffffff),
    TZ (0x1.0000000000001p31, 0x7fffffff),
    TZ (0x1p31, 0x7fffffff),
    TZ (0x1.fffffffffffffp30, 0x7fffffff),
    TZ (0x1.fffffffcp30, 0x7fffffff),
    T (1.6, 2, 1, 2, 1),
    T (1.5, 2, 1, 2, 1),
    T (1.4, 1, 1, 2, 1),
    TZ (1.0, 1),
    T (0.6, 1, 0, 1, 0),
    T (0.5, 0, 0, 1, 0),
    T (0.4, 0, 0, 1, 0),
    T (0x1p-1074, 0, 0, 1, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    T (-0x1p-1074, 0, 0, 0, -1),
    T (-0.4, 0, 0, 0, -1),
    T (-0.5, 0, 0, 0, -1),
    T (-0.6, -1, 0, 0, -1),
    TZ (-1.0, -1),
    T (-1.4, -1, -1, -1, -2),
    T (-1.5, -2, -1, -1, -2),
    T (-1.6, -2, -1, -1, -2),
    TZ (-0x1.fffffffcp30, 0x80000001),
    T (-0x1.fffffffffffffp30, 0x80000000, 0x80000001, 0x80000001, 0x80000000),
    TZ (-0x1p31, 0x80000000),
    TZ (-0x1.0000000000001p31, 0x80000000),
    TZ (-0x1.fffffffffffffp1023, 0x80000000),
    TZ (-INFD, 0x80000000),
    TZ (-NAND, 0),
  };

static const struct double_test_data efdctui_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0xffffffff),
    TZ (0x1.fffffffffffffp1023, 0xffffffff),
    TZ (0x1.0000000000001p32, 0xffffffff),
    TZ (0x1p32, 0xffffffff),
    TZ (0x1.fffffffffffffp31, 0xffffffff),
    T (1.6, 2, 1, 2, 1),
    T (1.5, 2, 1, 2, 1),
    T (1.4, 1, 1, 2, 1),
    TZ (1.0, 1),
    T (0.6, 1, 0, 1, 0),
    T (0.5, 0, 0, 1, 0),
    T (0.4, 0, 0, 1, 0),
    T (0x1p-1074, 0, 0, 1, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    TZ (-0x1p-1074, 0),
    TZ (-0.4, 0),
    TZ (-0.5, 0),
    TZ (-0.6, 0),
    TZ (-1.0, 0),
    TZ (-1.4, 0),
    TZ (-1.5, 0),
    TZ (-1.6, 0),
    TZ (-0x1.fffffffffffffp1023, 0),
    TZ (-INFD, 0),
    TZ (-NAND, 0),
  };

static const struct float_test_data efsctsf_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0x7fffffff),
    TZ (0x1.fffffep127f, 0x7fffffff),
    TZ (0x1.000002p0f, 0x7fffffff),
    TZ (1.0f, 0x7fffffff),
    TZ (0x1.fffffep-1f, 0x7fffff80),
    TZ (0xffffff.0p-31f, 0xffffff),
    T (0x7fffff.8p-31f, 0x800000, 0x7fffff, 0x800000, 0x7fffff),
    T (0x7ffffe.8p-31f, 0x7ffffe, 0x7ffffe, 0x7fffff, 0x7ffffe),
    T (0x1.9p-31f, 2, 1, 2, 1),
    T (0x1.8p-31f, 2, 1, 2, 1),
    T (0x1.7p-31f, 1, 1, 2, 1),
    TZ (0x1p-31f, 1),
    T (0x0.9p-31f, 1, 0, 1, 0),
    T (0x0.8p-31f, 0, 0, 1, 0),
    T (0x0.7p-31f, 0, 0, 1, 0),
    T (0x1p-149f, 0, 0, 1, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    T (-0x1p-149f, 0, 0, 0, -1),
    T (-0x0.7p-31f, 0, 0, 0, -1),
    T (-0x0.8p-31f, 0, 0, 0, -1),
    T (-0x0.9p-31f, -1, 0, 0, -1),
    TZ (-0x1p-31f, -1),
    T (-0x1.7p-31f, -1, -1, -1, -2),
    T (-0x1.8p-31f, -2, -1, -1, -2),
    T (-0x1.9p-31f, -2, -1, -1, -2),
    T (-0x7ffffe.8p-31f, -0x7ffffe, -0x7ffffe, -0x7ffffe, -0x7fffff),
    T (-0x7fffff.8p-31f, -0x800000, -0x7fffff, -0x7fffff, -0x800000),
    TZ (-0xffffff.0p-31f, -0xffffff),
    TZ (-0x1.fffffep-1f, -0x7fffff80),
    TZ (-1.0f, 0x80000000),
    TZ (-0x1.000002p0f, 0x80000000),
    TZ (-0x1.fffffep127f, 0x80000000),
    TZ (-INFF, 0x80000000),
    TZ (-NANF, 0),
  };

static const struct float_test_data efsctuf_test_data[] =
  {
    TZ (NANF, 0),
    TZ (INFF, 0xffffffff),
    TZ (0x1.fffffep127f, 0xffffffff),
    TZ (0x1.000002p0f, 0xffffffff),
    TZ (1.0f, 0xffffffff),
    TZ (0x1.fffffep-1f, 0xffffff00),
    TZ (0xffffff.0p-32f, 0xffffff),
    T (0x7fffff.8p-32f, 0x800000, 0x7fffff, 0x800000, 0x7fffff),
    T (0x7ffffe.8p-32f, 0x7ffffe, 0x7ffffe, 0x7fffff, 0x7ffffe),
    T (0x1.9p-32f, 2, 1, 2, 1),
    T (0x1.8p-32f, 2, 1, 2, 1),
    T (0x1.7p-32f, 1, 1, 2, 1),
    TZ (0x1p-32f, 1),
    T (0x0.9p-32f, 1, 0, 1, 0),
    T (0x0.8p-32f, 0, 0, 1, 0),
    T (0x0.7p-32f, 0, 0, 1, 0),
    T (0x1p-149f, 0, 0, 1, 0),
    TZ (0.0f, 0),
    TZ (-0.0f, 0),
    TZ (-0x1p-149f, 0),
    TZ (-0x0.7p-32f, 0),
    TZ (-0x0.8p-32f, 0),
    TZ (-0x0.9p-32f, 0),
    TZ (-0x1p-32f, 0),
    TZ (-0x1.7p-32f, 0),
    TZ (-0x1.8p-32f, 0),
    TZ (-0x1.9p-32f, 0),
    TZ (-0x7ffffe.8p-32f, 0),
    TZ (-0x7fffff.8p-32f, 0),
    TZ (-0xffffff.0p-32f, 0),
    TZ (-0x1.fffffep-1f, 0),
    TZ (-1.0f, 0),
    TZ (-0x1.000002p0f, 0),
    TZ (-0x1.fffffep127f, 0),
    TZ (-INFF, 0),
    TZ (-NANF, 0),
  };

static const struct double_test_data efdctsf_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0x7fffffff),
    TZ (0x1.fffffffffffffp1023, 0x7fffffff),
    TZ (0x1.0000000000001p0, 0x7fffffff),
    TZ (1.0, 0x7fffffff),
    TZ (0x7fffffffp-31, 0x7fffffff),
    T (0x7fffff.8p-31, 0x800000, 0x7fffff, 0x800000, 0x7fffff),
    T (0x7ffffe.8p-31, 0x7ffffe, 0x7ffffe, 0x7fffff, 0x7ffffe),
    T (0x1.9p-31, 2, 1, 2, 1),
    T (0x1.8p-31, 2, 1, 2, 1),
    T (0x1.7p-31, 1, 1, 2, 1),
    TZ (0x1p-31, 1),
    T (0x0.9p-31, 1, 0, 1, 0),
    T (0x0.8p-31, 0, 0, 1, 0),
    T (0x0.7p-31, 0, 0, 1, 0),
    T (0x1p-1074, 0, 0, 1, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    T (-0x1p-1074, 0, 0, 0, -1),
    T (-0x0.7p-31, 0, 0, 0, -1),
    T (-0x0.8p-31, 0, 0, 0, -1),
    T (-0x0.9p-31, -1, 0, 0, -1),
    TZ (-0x1p-31, -1),
    T (-0x1.7p-31, -1, -1, -1, -2),
    T (-0x1.8p-31, -2, -1, -1, -2),
    T (-0x1.9p-31, -2, -1, -1, -2),
    T (-0x7ffffe.8p-31, -0x7ffffe, -0x7ffffe, -0x7ffffe, -0x7fffff),
    T (-0x7fffff.8p-31, -0x800000, -0x7fffff, -0x7fffff, -0x800000),
    TZ (-0x7fffffffp-31, -0x7fffffff),
    TZ (-1.0, 0x80000000),
    TZ (-0x1.0000000000001p0, 0x80000000),
    TZ (-0x1.fffffffffffffp1023, 0x80000000),
    TZ (-INFD, 0x80000000),
    TZ (-NAND, 0),
  };

static const struct double_test_data efdctuf_test_data[] =
  {
    TZ (NAND, 0),
    TZ (INFD, 0xffffffff),
    TZ (0x1.fffffffffffffp1023, 0xffffffff),
    TZ (0x1.0000000000001p0, 0xffffffff),
    TZ (1.0, 0xffffffff),
    TZ (0xffffffffp-32, 0xffffffff),
    T (0xfffffffe.9p-32, 0xffffffff, 0xfffffffe, 0xffffffff, 0xfffffffe),
    T (0xfffffffe.8p-32, 0xfffffffe, 0xfffffffe, 0xffffffff, 0xfffffffe),
    T (0xfffffffe.7p-32, 0xfffffffe, 0xfffffffe, 0xffffffff, 0xfffffffe),
    T (0xfffffffd.9p-32, 0xfffffffe, 0xfffffffd, 0xfffffffe, 0xfffffffd),
    T (0xfffffffd.8p-32, 0xfffffffe, 0xfffffffd, 0xfffffffe, 0xfffffffd),
    T (0xfffffffd.7p-32, 0xfffffffd, 0xfffffffd, 0xfffffffe, 0xfffffffd),
    T (0x7fffff.8p-32, 0x800000, 0x7fffff, 0x800000, 0x7fffff),
    T (0x7ffffe.8p-32, 0x7ffffe, 0x7ffffe, 0x7fffff, 0x7ffffe),
    T (0x1.9p-32, 2, 1, 2, 1),
    T (0x1.8p-32, 2, 1, 2, 1),
    T (0x1.7p-32, 1, 1, 2, 1),
    TZ (0x1p-32, 1),
    T (0x0.9p-32, 1, 0, 1, 0),
    T (0x0.8p-32, 0, 0, 1, 0),
    T (0x0.7p-32, 0, 0, 1, 0),
    T (0x1p-1074, 0, 0, 1, 0),
    TZ (0.0, 0),
    TZ (-0.0, 0),
    TZ (-0x1p-1074, 0),
    TZ (-0x0.7p-32, 0),
    TZ (-0x0.8p-32, 0),
    TZ (-0x0.9p-32, 0),
    TZ (-0x1p-32, 0),
    TZ (-0x1.7p-32, 0),
    TZ (-0x1.8p-32, 0),
    TZ (-0x1.9p-32, 0),
    TZ (-0x7ffffe.8p-32, 0),
    TZ (-0x7fffff.8p-32, 0),
    TZ (-0xfffffffd.7p-32, 0),
    TZ (-0xfffffffd.8p-32, 0),
    TZ (-0xfffffffd.9p-32, 0),
    TZ (-0xfffffffe.7p-32, 0),
    TZ (-0xfffffffe.8p-32, 0),
    TZ (-0xfffffffe.9p-32, 0),
    TZ (-0xffffffffp-32, 0),
    TZ (-1.0, 0),
    TZ (-0x1.0000000000001p0, 0),
    TZ (-0x1.fffffffffffffp1023, 0),
    TZ (-INFD, 0),
    TZ (-NAND, 0),
  };

RUN_FLOAT_TESTS (efsctsiz)
RUN_VFLOAT_TESTS (evfsctsiz, efsctsiz)
RUN_FLOAT_TESTS (efsctuiz)
RUN_VFLOAT_TESTS (evfsctuiz, efsctuiz)
RUN_FLOAT_TESTS (efdctsiz)
RUN_FLOAT_TESTS (efdctuiz)

RUN_FLOAT_TESTS (efsctsi)
RUN_VFLOAT_TESTS (evfsctsi, efsctsi)
RUN_FLOAT_TESTS (efsctui)
RUN_VFLOAT_TESTS (evfsctui, efsctui)
RUN_FLOAT_TESTS (efdctsi)
RUN_FLOAT_TESTS (efdctui)

RUN_FLOAT_TESTS (efsctsf)
RUN_VFLOAT_TESTS (evfsctsf, efsctsf)
RUN_FLOAT_TESTS (efsctuf)
RUN_VFLOAT_TESTS (evfsctuf, efsctuf)
RUN_FLOAT_TESTS (efdctsf)
RUN_FLOAT_TESTS (efdctuf)

int
main (void)
{
  test_efsctsiz ();
  test_evfsctsiz ();
  test_efsctuiz ();
  test_evfsctuiz ();
  test_efdctsiz ();
  test_efdctuiz ();
  test_efsctsi ();
  test_evfsctsi ();
  test_efsctui ();
  test_evfsctui ();
  test_efdctsi ();
  test_efdctui ();
  test_efsctsf ();
  test_evfsctsf ();
  test_efsctuf ();
  test_evfsctuf ();
  test_efdctsf ();
  test_efdctuf ();
  printf ("%d tests passed, %d tests failed\n", success_count, failure_count);
  exit (failure_count != 0 ? EXIT_FAILURE : EXIT_SUCCESS);
}

-- 
Joseph S. Myers
joseph@codesourcery.com
