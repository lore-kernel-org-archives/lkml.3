Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbaGYHXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:23:50 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:34482 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbaGYHXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:23:49 -0400
Message-ID: <53D205F2.1040901@tu-dresden.de>
Date: Fri, 25 Jul 2014 09:23:30 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] perf tools: Fix make PYTHON override
References: <53D135F9.1070104@tu-dresden.de> <1406258045-25726-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1406258045-25726-1-git-send-email-namhyung@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060901050307050804090009"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060901050307050804090009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Namhyung,

On 2014-07-25 05:14, Namhyung Kim wrote:
> Thomas reported that make PYTHON=3Dpython2 is not work on some systems.=

> I can reproduce it on my ArchLinux box too.
>=20
> This is because it's overridden by config/feature-checks/Makefile
> regardless of PYTHON setting.  I guess it's a bug slipped into during
> the feature checking change.
>=20
> Actually, we don't need to check python-config in the feature-checks.
> We can just pass appropriate FEATURE_CHECK_*FLAGS.

The patch works fine for me.

Thanks,
Thomas

>=20
> Reported-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/config/Makefile                | 34 ++++++++++++++++++++---=
--------
>  tools/perf/config/feature-checks/Makefile | 18 ++--------------
>  2 files changed, 24 insertions(+), 28 deletions(-)
>=20
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 1f67aa02d240..e05d8f99424d 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -120,6 +120,23 @@ ifdef PARSER_DEBUG
>    CFLAGS             +=3D -DPARSER_DEBUG
>  endif
> =20
> +ifndef NO_LIBPYTHON
> +  override PYTHON :=3D \
> +    $(call get-executable-or-default,PYTHON,python)
> +  override PYTHON_CONFIG :=3D \
> +    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
> +
> +  PYTHON_CONFIG_SQ :=3D $(call shell-sq,$(PYTHON_CONFIG))
> +
> +  PYTHON_EMBED_LDOPTS :=3D $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/de=
v/null)
> +  PYTHON_EMBED_CCOPTS :=3D $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev=
/null)
> +
> +  FEATURE_CHECK_CFLAGS-libpython :=3D $(PYTHON_EMBED_CCOPTS)
> +  FEATURE_CHECK_LDFLAGS-libpython :=3D $(PYTHON_EMBED_LDOPTS)
> +  FEATURE_CHECK_CFLAGS-libpython-version :=3D $(PYTHON_EMBED_CCOPTS)
> +  FEATURE_CHECK_LDFLAGS-libpython-version :=3D $(PYTHON_EMBED_LDOPTS)
> +endif
> +
>  CFLAGS +=3D -fno-omit-frame-pointer
>  CFLAGS +=3D -ggdb3
>  CFLAGS +=3D -funwind-tables
> @@ -482,21 +499,14 @@ define disable-python_code
>    NO_LIBPYTHON :=3D 1
>  endef
> =20
> -override PYTHON :=3D \
> -  $(call get-executable-or-default,PYTHON,python)
> -
> -ifndef PYTHON
> -  $(call disable-python,python interpreter)
> +ifdef NO_LIBPYTHON
> +  $(call disable-python)
>  else
> =20
> -  PYTHON_WORD :=3D $(call shell-wordify,$(PYTHON))
> -
> -  ifdef NO_LIBPYTHON
> -    $(call disable-python)
> +  ifndef PYTHON
> +    $(call disable-python,python interpreter)
>    else
> -
> -    override PYTHON_CONFIG :=3D \
> -      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)=

> +    PYTHON_WORD :=3D $(call shell-wordify,$(PYTHON))
> =20
>      ifndef PYTHON_CONFIG
>        $(call disable-python,python-config tool)
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/con=
fig/feature-checks/Makefile
> index 6088f8d8a434..72ab2984718e 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -101,25 +101,11 @@ FLAGS_PERL_EMBED=3D$(PERL_EMBED_CCOPTS) $(PERL_EM=
BED_LDOPTS)
>  test-libperl.bin:
>  	$(BUILD) $(FLAGS_PERL_EMBED)
> =20
> -override PYTHON :=3D python
> -override PYTHON_CONFIG :=3D python-config
> -
> -escape-for-shell-sq =3D  $(subst ','\'',$(1))
> -shell-sq =3D '$(escape-for-shell-sq)'
> -
> -PYTHON_CONFIG_SQ =3D $(call shell-sq,$(PYTHON_CONFIG))
> -
> -PYTHON_EMBED_LDOPTS =3D $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/n=
ull)
> -PYTHON_EMBED_LDFLAGS =3D $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
> -PYTHON_EMBED_LIBADD =3D $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
> -PYTHON_EMBED_CCOPTS =3D $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/nu=
ll)
> -FLAGS_PYTHON_EMBED =3D $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
> -
>  test-libpython.bin:
> -	$(BUILD) $(FLAGS_PYTHON_EMBED)
> +	$(BUILD)
> =20
>  test-libpython-version.bin:
> -	$(BUILD) $(FLAGS_PYTHON_EMBED)
> +	$(BUILD)
> =20
>  test-libbfd.bin:
>  	$(BUILD) -DPACKAGE=3D'"perf"' -lbfd -lz -liberty -ldl
>=20

--=20
Dipl. Inf. Thomas Ilsche
Computer Scientist
Highly Adaptive Energy-Efficient Computing
CRC 912 HAEC: http://tu-dresden.de/sfb912
Technische Universit=E4t Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-42168
Fax: +49 351 463-3773
E-Mail: thomas.ilsche@tu-dresden.de


--------------ms060901050307050804090009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPhTCC
BHQwggNcoAMCAQICCQCJkBEVWD6HmzANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0
IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwMjEx
MTMxMTQ1WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZl
cmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFs
IC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1
PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXst
kEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QP
wQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz
2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXF
bOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgEG
MB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT1xfg
iXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweQYIKwYBBQUHAQEE
bTBrMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA7Bggr
BgEFBQcwAoYvaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0FfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBACwvqeBeQy8FcNxRlXVdgI47DMFjWFSBMIOcXalRh8m2
1w8runhIJGBCzPGi4jPhMh4ym1ETlXnGtazQJO0YFLwvKuovq7ITrEkdXgALBBhqmmXU6Ec1
vK7t33S22PGAUGWgxtojm41TR8psu0DJlV1OYHor5LtmQFWvtjPB6iMhbvxUnd0zQm5Ma9Xk
w/LqBrdaMmoyRXS2tW/+6v8cY6q7iNH4WK8gfo+///b3OHeLGrZQP609R3lGw1e0F2KHvZ6j
NiUHaCSqIvL2rynsN6UUma66AWCGdS1hFbp4loe1ks/hUJGeWToV7J5axob8KD5mutTZNa+t
PEkihYfub48wggVhMIIESaADAgECAgcXpCR5aFyOMA0GCSqGSIb3DQEBCwUAMFoxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQD
ExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMTQwNTI3MTQ1MzI5WhcNMTkwNzA5
MjM1OTAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0
YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcw
MjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCg
JeIPQmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8
OdgvD4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA
5Q5E4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoO
enVItm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3sn
AgMBAAGjggH+MIIB+jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjARBgNV
HSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFMUrU5MXg8n1RkLtQ2rftoCmR/LgMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEXBraUB0dS1kcmVzZGVuLmRl
MIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcowgccwMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCJ
hMBD4Oh4PXhRwECrWgomDDnELDDFh4FN1e2g0gYbKLg/kA0gw6RKImh4GhTRAbENxW2My+tH
aKFjtwQdBaanilk4DN581jqxjo37jPEwDmNNzT8U4ssiwmkMD2bWM2vTcc7lDj2g7w+sRzIJ
8zi1AtCV43bJT8xBVj0PQpFuqYVvYzgMq+KNtGn4YyiBAMyDY1EzPEgtOovN7sqXb3jGDa71
gqdHWIKf9orfDWCZ/Y8d+Y+rSqtBAHj0fnAzjnIgtJvUIif+Afx/4Rvxy0MHj3q6uHhPFcZ9
QBPm+vxX2nWXEMlJcf1A/Igdah5hUpkmAQIUUJso8QbE4gXBS/BPMIIFpDCCBIygAwIBAgIH
FyxZ1i7USDANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2hu
aXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUg
RHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcN
MTQwMjI1MTgwOTExWhcNMTcwMjI0MTgwOTExWjBdMQswCQYDVQQGEwJERTEoMCYGA1UEChMf
VGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRYwFAYDVQQD
Ew1UaG9tYXMgSWxzY2hlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzxoc9lcS
97ONeAVS1Y361WCBX3sCjHlopnPOgLGsscTI3jd75BxiAeSCvFwu9POGs2vsIHeiKKQyu+3F
s3QHKbewYH/E9D5dcJ8VtKFBL0jU7NaXm8jLY/0nPOOX1t8OGdykV1Hio7KH5RyyOX/XZ6cs
DNRFNACcOMyMTHuSIcMX4htxPmiLsNBXTQ0Ohf/7WClIRIXxYO0EMMA/4Fb3WC23YdPSedJr
RRU/cs0nKcV4g6O14ZfvzN3hQFqs06TBhde3Mv+yUyKHalaOoggNlBqjRXh6KyCYDZnou6Bm
S1EQs+UchWU6jo8WXaKbadJpaIxL3HtcV5JFHZOibtmzJQIDAQABo4ICPjCCAjowLwYDVR0g
BCgwJjARBg8rBgEEAYGtIYIsAQEEAwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQCMAAw
CwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU
tl3TKO1q/IByitqlWh99jrj7AagwHwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH8uAw
JgYDVR0RBB8wHYEbdGhvbWFzLmlsc2NoZUB0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAw
PqA8oDqGOGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2df
Y2FjcmwuY3JsMD6gPKA6hjhodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NybC9nX2NhY3JsLmNybDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0
dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0
cDovL2NkcDEucGNhLmRmbi5kZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQu
Y3J0MEgGCCsGAQUFBzAChjxodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NhY2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBADkeZ80dWsjpjOkn
/Rk/1nBWHj139rRsPNCrwr2CZLHLiO9pB6SYTx9W5/7v5hg8883E9ProF/h+nhKiaLtNxsBw
jx8a1v8Uz4buJSeYsFs0wEl3sOoCsfwVNjgJ++AcYu8zsOaalIzeBc4dOiP7gMyN6vyODX3H
HJSySzuffl+ywGQCJWcsjNrOnrRYw99vmKcLB9aI728AMNr/ugJcIGcEfu6ABtECHDhsgYKS
iS+KElT7Yqak4Up7Ji+Q03l4r0s6e9NjT+nScN5ap8g30j0PRWdsQ/fxpM5cwP8nP3if7i5p
3Qy5GEnIEusfkLFckPVLJhRYtL1+kJOVsUs+S4gxggPUMIID0AIBATCBkTCBhTELMAkGA1UE
BhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNV
BAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYR
cGtpQHR1LWRyZXNkZW4uZGUCBxcsWdYu1EgwCQYFKw4DAhoFAKCCAhcwGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNzI1MDcyMzMwWjAjBgkqhkiG9w0B
CQQxFgQUTWFH6saVMWuc2UMLe9aZaRL4SPcwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQsw
CQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEM
MAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcN
AQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIHFyxZ1i7USDCBpAYLKoZIhvcNAQkQAgsxgZSggZEw
gYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVz
ZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkq
hkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlAgcXLFnWLtRIMA0GCSqGSIb3DQEBAQUABIIB
AAdYGp8N5Yk2+XriszuGLREh2NQGh1EcNFeb05M0JgpAHOSKD3o5PS1wZAjudZeLV8AqVq55
2CJZMP7rWySOy+ZB8PffaeCHZP7L5gK1ezz7fhilmdBoMKSq4LWs12ROPwzOdL9OoPOwsg0P
5oeZP//uti2P/NfDGLPm0iPA7g/gKsM6TB1BgLy0Hjb513XJW97twRs12x1hxZHqSC3h4pk0
Bdi+LAQGWpXFGUL8hb0cjQ2lTTMx5Bjr42prOqX6VBfJ91OsjusLd1OYVuIp7j2cVdWaxO3B
EIwu1lF1r+MARkW89s6Yu6ElJqpzmwEzBVZYppmx51dFVntZiCaIYToAAAAAAAA=
--------------ms060901050307050804090009--
