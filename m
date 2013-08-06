Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3HFXPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:15:37 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35865 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3HFXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:15:35 -0400
From: James Bates <james.h.bates@gmail.com>
Content-Type: multipart/signed; boundary="Apple-Mail=_5C5E50CA-5674-4358-9E4F-3C21F49A260E"; protocol="application/pkcs7-signature"; micalg=sha1
Subject: [PATCH] efifb: prevent null dereferences by removing unused array  indices from dmi_list
Message-Id: <C9C6655E-4974-4C04-8CEE-CA16563F4CC5@gmail.com>
Date: Wed, 7 Aug 2013 01:15:29 +0200
To: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_5C5E50CA-5674-4358-9E4F-3C21F49A260E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi all,

The dmi_list array is initialized using gnu designated initializers, and =
therefore
contains fewer explicitly defined entries as there are elements in it. =
This
is because the enum above with M_blabla constants contains more items =
than the designated
initializer. Those elements not explicitly initialized are implicitly =
set to 0.

Now efifb_setup(), L.322 & L.323, loops through all these array =
elements, and performs
a strcmp o a field (optname) in each item. For non explicitly =
initialized elements this
will be a null pointer:

                        for (i =3D 0; i < M_UNKNOWN; i++) {
                                if (!strcmp(this_opt, =
dmi_list[i].optname) &&

On my macbook6,1 the predefined values are for some reason incorrect, =
and most parameters
are preset correctly by my efi bootloader (elilo). but =
stride/line_length is not detected
correctly and so I wish to set it explicitly using a =
"video=3Defifb:stride:2048" command-line
argument. Because of the above null dereference, an exception =
(presumably) occurs before
the parsing code (L.333) is ever reached. I say presumably since the mac =
hangs on boot
without a console, and I can therefore not see any output.

By removing the unused values from the enum, and thus preventing =
implicitly initialized items
in the dmi_list array, the null dereference does not occur, my customer =
command-line arg is
parsed correctly, and my console displays correctly.

Signed-off-by: James Bates <james.h.bates@gmail.com>
---
 drivers/video/efifb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 50fe668..52d1d88 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -50,12 +50,9 @@ enum {
        M_MINI_3_1,     /* Mac Mini, 3,1th gen */
        M_MINI_4_1,     /* Mac Mini, 4,1th gen */
        M_MB,           /* MacBook */
-       M_MB_2,         /* MacBook, 2nd rev. */
-       M_MB_3,         /* MacBook, 3rd rev. */
        M_MB_5_1,       /* MacBook, 5th rev. */
        M_MB_6_1,       /* MacBook, 6th rev. */
        M_MB_7_1,       /* MacBook, 7th rev. */
-       M_MB_SR,        /* MacBook, 2nd gen, (Santa Rosa) */
        M_MBA,          /* MacBook Air */
        M_MBA_3,        /* Macbook Air, 3rd rev */
        M_MBP,          /* MacBook Pro */
--
1.7.12.4 (Apple Git-37)


--Apple-Mail=_5C5E50CA-5674-4358-9E4F-3C21F49A260E
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMijCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGTjCCBTag
AwIBAgIDBes+MA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTMwMjExMTAyMjA3WhcNMTQwMjExMjAwMTUzWjBlMRkwFwYDVQQNExA5aDNPOHBoSjg4U0Z3ZHkx
MSAwHgYDVQQDDBdqYW1lcy5oLmJhdGVzQGdtYWlsLmNvbTEmMCQGCSqGSIb3DQEJARYXamFtZXMu
aC5iYXRlc0BnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCoZT6ntgtK
I0mry4E+i3v+zK3I/y4g72Am+f+yX3Co1ksd6fhVRVO9wNfuxgHmLOfc+yDSIRls+OwPts/ESSS1
2MDlSLcptEGZ9bP5CcS8VQalyo+p78dM++k3krZ8VoT+osUaBk9/RT8wTb+Au9oSIYH/JswQySIY
RS37z7vdT+yM2B6t9AkKz8j/u/KxFGqdZ0GczvDIboqRrnJB0d9owK2bSSddbv6iBbxsnsiRc6sE
Peyib4MSJY4Vaecu9c9wJI9gbrc9l2QJ7nvLWHON97KsLI9UfXlskPqpw3cWSd6YA2OUUoMfacOs
wZmzamkWQm/Ngqo7QseFYxlwWa8fAgMBAAGjggLdMIIC2TAJBgNVHRMEAjAAMAsGA1UdDwQEAwIE
sDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFEt6dZNacpHlQ1r+DMJR
3vqnbz2JMB8GA1UdIwQYMBaAFFNy7ZKc4NrLAVx8fpY1TvLUuFGCMCIGA1UdEQQbMBmBF2phbWVz
LmguYmF0ZXNAZ21haWwuY29tMIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASow
LgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsGAQUF
BwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNl
cnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24g
cmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9y
IHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkg
b2JsaWdhdGlvbnMuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2Ny
dHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0
YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5z
dGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEACLG4XLN5hVe4cbS+sHWW
3euuKT9gGEBRLoZihCRu6WbvSlMsTlaF7ihPtTg9WCe4Rv8at+YQng09XaMAThzKU9YR7mH50zAS
k1UN+9msgTyrQwF9vj/wautTQ7UXCQf5lfWMF8TF/REH3pkmEb4wu+HzEoaIJm40lfSHyB50RNBy
Z+4xPbgOaH8IVkpg2YLLHKkaPl1KwhO6TEs2G/YclPXjB0/VUMo46eFwcLSV9178ID4NQBXU2Yrx
blzbRD+915afD6FPW1SYe9nErcJYtrwi10BReuHzn+moSdgerlRJXRx5DwsVdR+31wcpZ0y/XLQJ
yMROlTeCva7VqZDMbTGCA28wggNrAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3Rh
cnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EC
AwXrPjAJBgUrDgMCGgUAoIIBrzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xMzA4MDYyMzE1MjlaMCMGCSqGSIb3DQEJBDEWBBSGnQpJGnJmOjy01ObCPNjgvEflAjCB
pQYJKwYBBAGCNxAEMYGXMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRk
LjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMv
U3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwXrPjCBpwYL
KoZIhvcNAQkQAgsxgZeggZQwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQu
MSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9T
dGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDBes+MA0GCSqG
SIb3DQEBAQUABIIBAB2zZOUpRWorhbJu5ZjnlzsXDzrDV9ec50cbwjEL3y3CJ7Z8SNH8cZdEvNLt
lV2ykzTgLxpA9tTXBjjXZ2c0eNE3o9z/3LdBq6yQrbg2kpqTU+ULRwK/cLBP7LlzxvjldWK2Zcfx
LT4MT+wf5dd+lg556Zyv3nF3R7wo3ZCdDAsJXz05o+sfzkWfbzPIZpJbTLaQtH8SJ+1vdC9BbLlw
YtRcENTYiPfXTm3MCFU8fP4iHZYf7yrOgX8GjxIpZwCLj8iwNT3z3IStjk7FefgCbfEDo8F7AF5W
1Wzg/pD/0Z+4u8R9qY5e39NAvWd6fbm3k1EYSYBQsUVQMtmvEd3Vh5IAAAAAAAA=

--Apple-Mail=_5C5E50CA-5674-4358-9E4F-3C21F49A260E--
