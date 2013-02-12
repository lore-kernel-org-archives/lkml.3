Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab3BLS0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:26:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52399 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421Ab3BLS0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:26:10 -0500
Message-ID: <511A8922.6050908@zytor.com>
Date: Tue, 12 Feb 2013 10:25:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com> <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com> <511A7892.4020407@zytor.com> <CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com>
In-Reply-To: <CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------040902090103030701010001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040902090103030701010001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I just thought up this variant, I'm about to test it, but H.J., do you
see any problems with it?

#define itype(x) \
__typeof__(__builtin_choose_expr(sizeof(*(x)) > sizeof(0UL), 0ULL, 0UL))

I tried it out with a small test program (attached), and it seems to
work.  Next for using it in the kernel...

	-hpa


--------------040902090103030701010001
Content-Type: text/x-csrc;
 name="testgcc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="testgcc.c"

#include <stdio.h>
#include <stdlib.h>

#define itype(x) __typeof__(__builtin_choose_expr(sizeof(*(x)) > sizeof(0UL), 0ULL, 0UL))

int main(void)
{
  const char *a;
  const short *b;
  const int *c;
  const long *d;
  const long long *e;
  const void **p;

  itype(a) aa;
  itype(b) bb;
  itype(c) cc;
  itype(d) dd;
  itype(e) ee;
  itype(p) pp;

  aa = 1;
  bb = 2;
  cc = 3;
  dd = 4;
  ee = 5;
  pp = 6;

  printf("a = %zu\n", sizeof(aa));
  printf("b = %zu\n", sizeof(bb));
  printf("c = %zu\n", sizeof(cc));
  printf("d = %zu\n", sizeof(dd));
  printf("e = %zu\n", sizeof(ee));
  printf("p = %zu\n", sizeof(pp));

  return 0;
}

--------------040902090103030701010001--
