Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab3E1PRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:17:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535Ab3E1PRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:17:52 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Xn1WxGX5KtcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DnfiZ_E_S1gA:10 a=20KFwNOVAAAA:8 a=R6udKgrDHqWNsRHYv40A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=7cuQHSnjIaxRih8gr9wA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528151749.891035971@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 11:15:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] ring-buffer: Do not poll non allocated cpu buffers
References: <20130528151557.743203087@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Do-not-poll-non-allocated-cpu-buffers.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The tracing infrastructure sets up for possible CPUs, but it uses
the ring buffer polling, it is possible to call the ring buffer
polling code with a CPU that hasn't been allocated. This will cause
a kernel oops when it access a ring buffer cpu buffer that is part
of the possible cpus but hasn't been allocated yet as the CPU has never
been online.

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b59aea2..e444ff8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -620,6 +620,9 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, i=
nt cpu,
 	if (cpu =3D=3D RING_BUFFER_ALL_CPUS)
 		work =3D &buffer->irq_work;
 	else {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -EINVAL;
+
 		cpu_buffer =3D buffer->buffers[cpu];
 		work =3D &cpu_buffer->irq_work;
 	}
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRpMqdAAoJEOdOSU1xswtMMHgH+wfHYqowiQNuNd7eaoPIOoQm
r/16XzG/IwmvLN8Wd2d3pMj7MjxE8Hz+Yg0ZlB29T2P21yBjMAkIKTSjb4H86Xct
av/fX1RIfoECf6TqSFO/JnBNlcHLxG+1pIcJf2orcv3DJNqgxhRhz7ONIfZ4DSc2
y9PZ3z0mXLIRshfzKS5XcLvO0WlL2XDn4BXe2Q1oaP+P4habmHf9AIfda3YrTRZj
AJnFcw7Y/I1Z8Tqk6E3DERNKhKNg9vbDdIgZ/yh8voa3s6JmFw9fg1IIm7eJtYeQ
UltBqcQ13kBTcAKELMhf01vRYuvP/m5YpBQNUw9M6BXawKjZgQS4WXPFrKPAckk=
=Ljha
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
