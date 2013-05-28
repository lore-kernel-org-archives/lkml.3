Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab3E1PSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:18:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492Ab3E1PRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:17:51 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RnCj8zb86lkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3m_eAQ9VMh8A:10 a=VwQbUJbxAAAA:8 a=wKr-vzE-v0XePlxv0e4A:9 a=QEXdDO2ut3YA:10 a=VKcRuV_XBfOElDsTgRsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528151557.743203087@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 11:15:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: A couple of fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Two more fixes:

The first one was reported by Mauro Carvalho Chehab, where if a poll()
is done against a trace buffer for a CPU that has never been online,
it will crash the kernel, as buffers are only created when a CPU comes
on line, but the trace files are for all possible CPUs.

This fix is to check if the buffer was allocated and if not return -EINVAL.

That was the simple fix, the real fix is a bit more complex and not for
a -rc release. We could have the files created when the CPUs come online.
That would require some design changes.

The second one was reported by Peter Zijlstra. If the kernel command line
has ftrace=3Dnop, it will lock up the system on boot up. This is because
the new design for 3.10 has the nop tracer bootstrap the tracing subsystem.
When ftrace=3D<trace> is defined, when that tracer is registered, it
starts the tracing, but uses the nop tracer to clear things out.
What happened here was that ftrace=3Dnop caused the registering of nop
to start it and use nop before it was initialized.

The only thing nop needs to have done to initialize it is to have the
tracer point its current_tracer structure member to the nop tracer.
Doing that before registering the nop tracer makes everything work.

-- Steve

Please pull the latest trace-fixes-v3.10-rc3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc3

Tag SHA1: fc1bb352c272393813d3081ba40a2921a519acdb
Head SHA1: 6721cb60022629ae76365551f05d9658b8d14c55


Steven Rostedt (Red Hat) (2):
      tracing: Fix crash when ftrace=3Dnop on the kernel command line
      ring-buffer: Do not poll non allocated cpu buffers

----
 kernel/trace/ring_buffer.c |    3 +++
 kernel/trace/trace.c       |    9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRpMqYAAoJEOdOSU1xswtM2fsIALdHfrBft+A2swzFQfNSXlFg
e+Xt91GHnj1eSCzEMWvo9YcVmR/RC43cJhbyDFRYrb3jJdsc6iX/JwYgZhjdS1Yp
1gYrwf/wOvKKxqUxqGPiWXhvqTMHRszeIh0Fnw0Fs1ic1MNEyPDYzca2REVQeCEV
1MQFwhdL1VH71y8YrhwRunY6yxvmANOh3TeLbL/+j07GRZZB++UymVxOuAdJTVc5
CS2PcWjPjA6fi9Ye5BbUDWtm18oLVlD3eNFQden58xYuq7fg+b1DC11VEJKLY0rf
QrbyXJEzdVMS20oVeXpKkT4Y1jJU/42j1TfMaHEQwKhSUtEYkUkoU6bHhHcCB3k=
=5mKn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
