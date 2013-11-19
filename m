Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3KSMfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:35:53 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60286 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3KSMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:35:50 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 0/6] ima: support per-measurement templates
Date: Tue, 19 Nov 2013 13:33:39 +0100
Message-Id: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----3407AD7EC0B6E4BC262C243ABCA12FB4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------3407AD7EC0B6E4BC262C243ABCA12FB4

Hi everyone

one functionality that is missing in the new template management mechanism
is the possibility to specify a custom template format per-measurement entry.
Until now, once the template is determined from the kernel configuration
or from the kernel command line parameters 'ima_template' and ima_template_fmt',
this template is used to generate all measurements entries in the list.

However, it is desirable to differentiate information included in measurement
entries depending on the event type from which they are generated. To explain
the usefulness of the proposed modification, I'll make an example.

One feature coming soon is the addition of new template fields that represent
LSM labels applied either to the current process and to the inode being
measured. However, these information are not enough to capture the mapping
between the executable code loaded for a given subject. Indeed, for example
in SELinux, a type transition may occur if the type of the current process
and the type of the inode being executed are matched in a 'type_transition'
policy rule. In this case, the code should be mapped not to the label of the
current process but instead to the label in the credentials (stored in the
'linux_binprm' structure) being installed during the execution of the execve()
system call.

To correctly perform the mapping code - LSM label, it is needed to introduce
a new template field to represent the LSM label in the 'linux_binprm' structure
(e.g. with identifier 'target-subj') and a new IMA policy action
(e.g. measure_log_all) to record a measurement for every event that match
rule criteria, although the accessed inode has already been measured. Then,
assuming that the format of the default template is "d-ng|n-ng|subj|obj"
(digest + hash algo, long event name, subject LSM label, object LSM label),
the policy to capture the mapping should be:

---
measure_log_all func=BPRM_CHECK mask=MAY_EXEC \
    ima_template_fmt=d-ng|n-ng|subj|obj|target-subj
measure_log_all func=FILE_MMAP mask=MAY_EXEC
---

In the first rule, the default template is overridden with a template that
contains the label stored in the 'linux_binprm' structure. Thus, in the
resulting measurements list, all entries that record file execution will
include the additional template field, while those generated from the
mapping into memory of shared libraries will contain only fields listed
in the default template.



=== UPDATE ===

This new version of the patch set includes two important updates in respect
to the previous one. First, newly created templates are added to the created
linked list (whose head is the first element of the 'defined_templates' array)
to avoid duplicates. Second, instead of storing the template name or format
strings in the IMA policy structure (ima_rule_entry), this patch set records
directly the pointer to newly created template descriptors obtained from
the function ima_get_template_desc(). Callers of ima_alloc_init_template()
determine the template to be used to produce a new measurement entry
(the default template or that stored in a matched policy rule) and supply
it as argument to this function. The benefit of the latter change is that
template lookup operations happen only during IMA initialization or the
loading of a custom policy (before, lookup was done each time an event matches
a rule with a custom template to translate the name or format string into
a template descriptor).

Roberto Sassu


Roberto Sassu (6):
  ima: connect defined IMA templates through a linked list
  ima: added new template helper lookup_template_desc_by_fmt()
  ima: added ima_get_template_desc() for templates dynamic registration
  ima: added ima_template and ima_template_fmt new policy options
  ima: pass template descriptor to ima_alloc_init_template()
  ima: use custom template obtained from a matched policy rule

 Documentation/ABI/testing/ima_policy     |  6 ++-
 Documentation/security/IMA-templates.txt | 19 +++++----
 security/integrity/ima/ima.h             | 14 +++++--
 security/integrity/ima/ima_api.c         | 22 ++++++----
 security/integrity/ima/ima_init.c        |  3 +-
 security/integrity/ima/ima_main.c        |  6 ++-
 security/integrity/ima/ima_policy.c      | 37 ++++++++++++++++-
 security/integrity/ima/ima_template.c    | 70 ++++++++++++++++++++++++++++++--
 8 files changed, 147 insertions(+), 30 deletions(-)

-- 
1.8.1.4


------3407AD7EC0B6E4BC262C243ABCA12FB4
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTkxMjMzNDhaMCMGCSqG
SIb3DQEJBDEWBBTae4yo0HZgGEUO7jDlTTUmeA8LtjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAsB790w8J/4J+B27A7Qu2vt5pC
otdzXFQf2Hso7qf7CrJzvRm6SvffpNfsaV9ldGynk7x+CubFPJjB2etrWZxIRJyx
vV4BOdljxKbmKKyfu9+EMqJTOrlENCcDkl08WkLe2CvZYKntgYGGZuP5Yk17eoQt
/MG+roXNCQSrYFFs3wJPnVXCZdECmwOyaJBpvmYoKY/KV5CB3KsPkpbdKHWBJlL8
7mRYKoYARpo8pfYxVx2lfS0zEw5ojJmYEEx0d/LTA8YHYDXxa+L3qw9oN+iqNL3Q
22x/T+v8Ui1zJFQgVkP4GMegyABdbpBo0BnSY803EDr6zR2cbH3wer0S3O8d

------3407AD7EC0B6E4BC262C243ABCA12FB4--


