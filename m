Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3IKOIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:08:47 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:51072 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:08:45 -0400
Date: Wed, 11 Sep 2013 11:08:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20130911140822.GD1866@ghostprotocols.net>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
 <20130911055503.GB15395@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911055503.GB15395@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 11, 2013 at 07:55:03AM +0200, Ingo Molnar escreveu:
>  16645 perf_event_open(0x1eb7f00, 0xffffffff, 0, 0xffffffff, 0) = -1 EINVAL (Invalid argument)
> 
> Caused by:
> 
>  575a9aab0f85 perf tools: Add attr->mmap2 support
> 
> We must not force mmap2 support to be present on the kernel side - new 
> perf top should work on older kernels just as well.
> 
> So I've unpulled the tree for now.

yeah, I noticed this late yesterday, made it to work like the fallback
for perf_event_attr.{sample_id_all,exclude_{guest,host}} and folded that
into Stephane's patch, with a committer note, to keep things bisectable.

Can you please do a test pull with the updated branch + tag below? If
you prefer me to do the whole dance and send a regular pull request,
please let me now.

- Arnaldo

tag perf-urgent-for-mingo
Tagger: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Sep 11 10:59:37 2013 -0300

perf/urgent fixes:

. Handle perf.data files with no tracepoints in 'perf trace', fixing a
  segfault.

. Fix up MMAP2 buffer space reservation, a problem that was caught via
  'perf test' consistency tests.

. Add attr->mmap2 support in the tools, a patch that should've been merged
  together with the kernel counterpart:

    13d7a24 "perf: Add attr->mmap2 attribute to an event".

  Merging it allowed us to catch the MMAP buffer space reservation problem via
  'perf test'. From Stephane Eranian.

  The tools deals with older kernels by disabling this feature, resetting the
  perf_event_attr.mmap2 bit, when -EINVAL is returned by perf_event_open, just
  like with perf_event_attr.{sample_id_all,exclude_{guest,host}}.

  When such fallback happens the perf_missing_features.mmap2 flag is set to
  true and can be used by tooling that strictly needs this feature to check
  for its availability on the running kernel.

. Make sure we can find PERF_SAMPLE_ID in the variable part of PERF_RECORD_
  ring buffer records in 'perf kvm', where direct manipulation of sample_type
  was being done.

  Fixed by making use of the perf_evlist__set_sample_bit() helper and by
  setting the evlist->id_pos in perf_evlist__open(), from Adrian Hunter.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABAgAGBQJSMHggAAoJENZQFvNTUqpAGwcP/jPE/xxeyX8+qzCfTs3+I8rs
2vQlqrkHxILF4yFIL9LmPc/cjknfZ2681Z8ExQoRZkwIhnFpPXo3pifpBpUgMpDY
sX6oYnevtlg2R1UfEZkpqzpudTalnhvpXapqcyG/ITr83lz4aqRQuB6BEHO/Rk9u
FSIar2sov84ZrtgCN5xdrl8eEjqtCM21EmKVGUhsTTeHzjCEE5zNairEPcbkY3j1
diQxk2V4pp3gdAniSkRQ52nwNiQphcUKk9aN2/UdQmzgVJ4JUu6Pl8VpvMeWe0gt
sk6j78YUYJY9rW64sRt4JNAh2/70OUp5pQ5z+uYF6xBYTc1isxxGwC+IR/L0FzJe
h5yvVIglzKL7LIkT076VzCI44kgGXEtvoqPOnTmCYSXuPNbKfdzFaK9zOr59qvHo
5gd4caPq0OsEC5dpsWkXm/awzrnUpUa7CuVO+2giW6aWxv8/XtbSdoVESaD4qVDG
X+KK/lnRI1mH28bZDzR4MxbfXsB8JA4b78sTjk3QAX5jusCPwzdmzg+WtZY6CsQg
k/PGT6Pu3YLh0QPCV/1tYqRKPOT1T8Vzvoc/xNX8Yr/KnkV94Deu4otBwOSpthBi
7BUfngXF31bOZxOUpnzoZb3DBFrJjNsHXy78QiIpv5f1DjpfRcDe54+hYxM9uAS1
sD+gvcG60j2mPwpp1ju+
=S8gx
-----END PGP SIGNATURE-----

