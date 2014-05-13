Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaEMPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbaEMPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:31:08 -0400
Message-ID: <53723A61.4020601@redhat.com>
Date: Tue, 13 May 2014 09:29:37 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Mueller <mimu@linux.vnet.ibm.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, Alexander Graf <agraf@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 09/10] QEMU: s390: cpu model QMP query-cpu-model
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com> <1399993222-16339-10-git-send-email-mimu@linux.vnet.ibm.com>
In-Reply-To: <1399993222-16339-10-git-send-email-mimu@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oh9VwbwkUM0iwPL7Ie6cxfo4E6tjX6AHW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oh9VwbwkUM0iwPL7Ie6cxfo4E6tjX6AHW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/13/2014 09:00 AM, Michael Mueller wrote:
> This patch implements a new QMP request named "query-cpu-model". It ret=
urns
> the cpu model of cpu 0. eg:
>=20
> request: '{"execute" : "query-cpu-model" }
> answer:  '{"return" : {"name": "2827-ga2"}}
>=20
> Alias names are resolved to their respective machine type and GA names
> already during cpu instantiation. Thus, also a cpu name like "host",
> which is implemented as alias, will return its normalized cpu model nam=
e.
>=20

> +    }
> +    cpu_model =3D g_try_malloc0(sizeof(*cpu_model));

It's simpler to just use g_malloc0 and rely on glibc's exit-on-OOM
behavior than to try and deal with NULL - this isn't user input (so
unlikely to be so huge as to cause OOM), and would be more in line with
what most other QMP code does.  But that said...

> +    if (!cpu_model) {
> +        goto out_no_mem;
> +    }
> +    cpu_model->name =3D g_try_malloc0(CPU_MODEL_NAME_LEN);
> +    if (!cpu_model->name) {
> +        goto out_no_mem;
> +    }
> +    snprintf(cpu_model->name, CPU_MODEL_NAME_LEN - 1, "%04x-ga%u",
> +             cc->proc->type, cc->mach->ga);

=2E..why not just use g_strdup_printf() instead of trying to size a buffe=
r
yourself?  In other words, skip the g_try_malloc0 to begin with.

The fact that you are packing two pieces of information into one string
is a bit worrisome - that means that the client of the QMP command has
to parse the string back into two pieces of information if they ever
need either item in isolation.  If the user never has a need to split
the name down into parts, you are okay; I don't know S390 well enough to
know whether anyone will care about type separate from ga.  But if
someone DOES care, then the QMP command should return the parts already
split, as in { "type": 2827, "ga": 2 }, or even as convenience provide
both split and combined forms: { "name": "2827-ga2", "type": 2827, "ga": =
2 }

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--oh9VwbwkUM0iwPL7Ie6cxfo4E6tjX6AHW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJTcjpiAAoJEKeha0olJ0NqnqAH/A6ztyI9nzH1EOf/s5Yee37D
jyRuVXqSoNuzppMo8k+8sqSk0ViMsD0jTgK5fI21WFpAWXWK0wfL1//E0ai8lUXZ
jO8s2/Zzg/9CrIDlkJ3kVdCD+st7/Jf6R4ArSn1fk/hL7Z9ARW4PiH6q1IWPXYxL
eQ4coAP4LenLJOkE4WhxgfLd2SCPVKB8W+hGil+OVZFBRlBNGIx1eiU1Tb4aq3Bx
9hJCcB4zoaakzSZhtci/D0yokZJKWyq97GZFAkHVan/sxyIN3LlkwDBq64C5zl8R
RFaB0M1lodptG3FhLESkcvuyNv64/Lf8bzBzjNNAxKFwSS+qVp+0HNw/djXeqn8=
=+08T
-----END PGP SIGNATURE-----

--oh9VwbwkUM0iwPL7Ie6cxfo4E6tjX6AHW--
