Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaFMErF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:47:05 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:50396 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaFMErE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 21:46:42 -0700
Message-ID: <CALCETrUsV9A9P1D5Au8jOf4ERun92MhLjK5hNhkfQNKHPaFhLQ@mail.gmail.com>
Subject: Re: vdso feature requests from the Go people
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Cox <rsc@golang.org>, Ian Taylor <iant@golang.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 9:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I was talking to some of the Go people, and they have a couple of IMO
> reasonable feature requests.
>
> 1. Parsing the vDSO is a PITA.  What if we bundled the reference
> parser inside the vdso?  Concretely, we could have AT_VDSO_FINDENTRY
> point to a function like:
>
> void *vdso_find_entry(const char *name, const char *version)
>
> Then things like Go and maybe even musl (and klibc?) could just call
> that function.  And we'd never have to worry about maintaining
> compatibility with more and more weird vdso parsers.
>
> Implementing this could be as simple as shoving parse_vdso.c into the
> vdso, although vdso2c could help and allow a really simple in-vdso
> implementation.
>
> 2. Go uses a segmented stack, and the vdso is quite unfriendly for
> segmented stack.  If we can get compiler support, is there a
> reasonable way that we could advertise the maximum stack usage of each
> vdso entry point?
>
>
> If we were to implement both, maybe we'd actually want to provide
> something like:
>
> struct vdso_entry {
>   unsigned long vdso_entry_struct_size;  /* so we can add fields later on */
>   void *func;
>   unsigned int max_stack;  /* zero if not known */
> };
>
> vdso_entry *vdso_find_entry(const char *name, const char *version);
>
> AT_VDSO_FINDENTRY would be set to &vdso_find_entry.
>
> This shouldn't even break CRIU :)
>

Alternatively we could just assign each entry a stable index and
supply a table: AT_VDSO_ENTRIES would point to:

struct {
  unsigned long nentries;
  vdso_entry entries[];
}

Simpler, faster, but less flexible.  This version wouldn't even need
help from vdso2c.

--Andy
