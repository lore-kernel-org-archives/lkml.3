Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3KTO3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:29:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KTO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:29:10 -0500
Message-ID: <1384957744.15487.58.camel@shinybook.infradead.org>
Subject: Re: [PATCH] iommu: Split iommu_unmaps
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Nov 2013 14:29:04 +0000
In-Reply-To: <1384211375.22415.69.camel@ul30vt.home>
References: <20130524171401.14099.78694.stgit@bling.home>
	 <1383842247.27315.117.camel@shinybook.infradead.org>
	 <1384211375.22415.69.camel@ul30vt.home>
Content-Type: multipart/signed; micalg="sha-1"; protocol="application/x-pkcs7-signature";
	boundary="=-uozoBV8YjNPTtHhsXq4u"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uozoBV8YjNPTtHhsXq4u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-11-11 at 16:09 -0700, Alex Williamson wrote:
> On Thu, 2013-11-07 at 16:37 +0000, David Woodhouse wrote:
> > On Fri, 2013-05-24 at 11:14 -0600, Alex Williamson wrote:
> > > iommu_map splits requests into pages that the iommu driver reports
> > > that it can handle.  The iommu_unmap path does not do the same.  This
> > > can cause problems not only from callers that might expect the same
> > > behavior as the map path, but even from the failure path of iommu_map=
,
> > > should it fail at a point where it has mapped and needs to unwind a
> > > set of pages that the iommu driver cannot handle directly.  amd_iommu=
,
> > > for example, will BUG_ON if asked to unmap a non power of 2 size.
> > >=20
> > > Fix this by extracting and generalizing the sizing code from the
> > > iommu_map path and use it for both map and unmap.
> > >=20
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >=20
> > Ick, this is horrid and looks like it will introduce a massive
> > performance hit.
>=20
> For x86 there are essentially two users of iommu_unmap(), KVM and VFIO.
> Both of them try to unmap an individual page and look at the result to
> see how much was actually unmapped.  Everything else appears to be error
> paths.  So where exactly is this massive performance hit?

It's there, in the code that you describe. This patch is making that
bogus behaviour even more firmly entrenched, and harder to fix.

There are out-of-tree users of this IOMMU API too. And while it sucks
that they are out-of-tree, they are working on fixing that. And I've
been talking to them about performance issues they already see on the
map side.

> > Surely the answer is to fix the AMD driver so that it will just get on
> > with it and unmap the {address, range} that it's asked to map?
>=20
> The IOMMU API allows iommu drivers to expose the page sizes they
> support.  Mappings are done using these sizes so it only seems fair that
> unmappings should as well.  At least that's what amd_iommu was
> expecting.

This is silly.

The generic code has (almost) no business caring about the page sizes
that the IOMMU driver will support. It should care about them *only* as
an optimisation =E2=80=94 "hey, if you manage to give me 2MiB pages I can w=
ork
faster then". But it should *only* be an optimisation. Fundamentally,
the map and unmap routines should just do as they're bloody told,
without expecting their caller to break down the calls into individual
pages.

> That data is for dma_ops interfaces, not IOMMU API.  How is changing
> iommu_unmap() in this way undoing any of your previous work?

That data is for the core map/unmap functions, which are accessed
through both APIs. While iommu_map() has the problem as you described,
iommu_unmap() didn't, and surely it would have been seeing the same
improvements... until this patch?

> > If the AMD driver really can't handle more than one page at a time, let
> > it loop for *itself* over the pages.
>=20
> Sure, but that's a change to the API where I think this fix was
> correcting a bug in the implementation of the API.  Are there users of
> iommu_unmap() that I don't know about?  Given the in-tree users, there's
> not really a compelling argument to optimize.  Thanks,

It's a fix to a stupid API, yes. The current API has us manually marking
the Intel IOMMU as supporting *all* sizes of pages, just so that this
stupid "one page at a time" nonsense doesn't bite so hard... which
should have raised alarm bells at the time we did it, really.

--=20
dwmw2


--=-uozoBV8YjNPTtHhsXq4u
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIISxDCCBjQw
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
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGQjCCBSqg
AwIBAgIDBoXOMA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTMwNTAyMDYyMDQ2WhcNMTQwNTAzMTIxNDAyWjBdMRkwFwYDVQQNExBNd0k3ODIxNTRpV21lZVkw
MRwwGgYDVQQDDBNkd213MkBpbmZyYWRlYWQub3JnMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZy
YWRlYWQub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvWGuRDHiXVpOgaFkBaz8
c3jQTfiEw7j0iKZnktCQi0xjY29QJ7GwL+fgQlbofXgYTm8E9fWERvw2tAy2BxHzAPguBzziS7JN
hsGP9lf3L8hFJBvmdyyyj8b9A6Oi7s3JLtMRWIvyvE+DbuTkP+htuT4+XuTJr8Y5yIqd1WXr2gJk
ANr77vTyjeNxceevP58Tqr0f+4v5g6+vNARO3bk3SaVQPDUTwGrpoPtLh3d+mQzZ4iiW3MwQS7Wr
UVT3l2aTVHCpgtAaBs3zHWarvmIqhbWj8zdcnELNzwqTrOjaoWxuWY4k05GGfzmdjOBUiL7FDNvI
ZwweJEPwJAQI72YhUwIDAQABo4IC2TCCAtUwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBSs0hZhUgQwqGVXzLuH6pJH0hMZwTAf
BgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAeBgNVHREEFzAVgRNkd213MkBpbmZyYWRl
YWQub3JnMIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASowLgYIKwYBBQUHAgEW
Imh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0
YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdh
cyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRz
IG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRl
ZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMu
MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmww
gY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9z
dWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20v
Y2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEACFLDQnyO8+XA/TiTltjJ/ZAvM+qmBEKN43Vd
+Wio2lM/Wq/scJpkupXGHrl9CueobkDxMAogXbMxqLZYO13PvgjMh+PHxDPnQv8EGxOig+k/Hqvc
qEdTlm9YEHcbXbWS6XB+zRO7VVIpGMYQ1f1qCOcukxmwIm6iMSHXbOr/7paQm4bO0ULptjBotfiO
Zo6q8No6SroQlOSyc6v8FYSxTNIAXMaM2FYkjqrxgdnJmSIAfr11gROuF69WuOICxP0zTEjJle+7
aO9lUWNaWMWPMyFSNCxF6kkRuvUCami7vlhLOTRC1kb+OMhx7keN9At3tdTI3rtuFeSB1Pa3VXVs
0DCCBkIwggUqoAMCAQICAwaFzjANBgkqhkiG9w0BAQUFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xp
ZW50IENBMB4XDTEzMDUwMjA2MjA0NloXDTE0MDUwMzEyMTQwMlowXTEZMBcGA1UEDRMQTXdJNzgy
MTU0aVdtZWVZMDEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzEiMCAGCSqGSIb3DQEJARYT
ZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL1hrkQx
4l1aToGhZAWs/HN40E34hMO49IimZ5LQkItMY2NvUCexsC/n4EJW6H14GE5vBPX1hEb8NrQMtgcR
8wD4Lgc84kuyTYbBj/ZX9y/IRSQb5ncsso/G/QOjou7NyS7TEViL8rxPg27k5D/obbk+Pl7kya/G
OciKndVl69oCZADa++708o3jcXHnrz+fE6q9H/uL+YOvrzQETt25N0mlUDw1E8Bq6aD7S4d3fpkM
2eIoltzMEEu1q1FU95dmk1RwqYLQGgbN8x1mq75iKoW1o/M3XJxCzc8Kk6zo2qFsblmOJNORhn85
nYzgVIi+xQzbyGcMHiRD8CQECO9mIVMCAwEAAaOCAtkwggLVMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUrNIWYVIEMKhlV8y7
h+qSR9ITGcEwHwYDVR0jBBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwHgYDVR0RBBcwFYETZHdt
dzJAaW5mcmFkZWFkLm9yZzCCAUwGA1UdIASCAUMwggE/MIIBOwYLKwYBBAGBtTcBAgMwggEqMC4G
CCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMIH3BggrBgEFBQcC
AjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0
aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBWYWxpZGF0aW9uIHJl
cXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0
aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5IG9i
bGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnR1
MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5zdGFy
dHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xpZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRw
Oi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBAAhSw0J8jvPlwP04k5bYyf2Q
LzPqpgRCjeN1XfloqNpTP1qv7HCaZLqVxh65fQrnqG5A8TAKIF2zMai2WDtdz74IzIfjx8Qz50L/
BBsTooPpPx6r3KhHU5ZvWBB3G121kulwfs0Tu1VSKRjGENX9agjnLpMZsCJuojEh12zq/+6WkJuG
ztFC6bYwaLX4jmaOqvDaOkq6EJTksnOr/BWEsUzSAFzGjNhWJI6q8YHZyZkiAH69dYETrhevVrji
AsT9M0xIyZXvu2jvZVFjWljFjzMhUjQsRepJEbr1Ampou75YSzk0QtZG/jjIce5HjfQLd7XUyN67
bhXkgdT2t1V1bNAxggNvMIIDawIBATCBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2
BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMG
hc4wCQYFKw4DAhoFAKCCAa8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTMxMTIwMTQyOTA0WjAjBgkqhkiG9w0BCQQxFgQU+uJz1/nit5gNgzWJZMS/kBs8YDkwgaUG
CSsGAQQBgjcQBDGBlzCBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4x
KzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0
YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMGhc4wgacGCyqG
SIb3DQEJEAILMYGXoIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEr
MCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3Rh
cnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwaFzjANBgkqhkiG
9w0BAQEFAASCAQA0LJDD41BrxZ1AOm5Rf7SVdrhmlO8pSU9dARiRvpTWdcWSEu9UZMLqHIp2wi9g
MxZjG9SnQgmI1BBoGEEaEFimVvXtz3/mrjfVZMbgE3q0RxhzvlyemrL3zzqJ+E4j0De+yQhrX08e
P1N9DQLXHdkF+crvslUc4KlDyAGdodVo3FZOAarGJP22mjRZlmBpKEU/6kRY9swWyjgFY9xL+hsv
EgF9rOqCSAvpMqdGXnx1BUig9CxqYQm+3TuG/PRVPYS4A3HTC832hXkWSN27v6Z6kMAkJMq4cmAf
Vsh4fpWf5ZG2p8aG18Nut2lPqVEDGhhHIOHZxAA/ovWjz2EUIvpDAAAAAAAA


--=-uozoBV8YjNPTtHhsXq4u--

