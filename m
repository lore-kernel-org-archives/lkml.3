Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaIKRUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:20:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60604 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:20:45 -0400
Message-ID: <5411D9E2.5030408@gmail.com>
Date: Thu, 11 Sep 2014 13:20:34 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] memcg: add threshold for anon rss
References: <cover.1410447097.git.vdavydov@parallels.com> <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov@parallels.com>
In-Reply-To: <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov@parallels.com>
x-hashcash: 1:21:140911:vdavydov@parallels.com::4778fb37d796af725d2cb372966ea90:f6081fab8d488ba5
x-hashcash: 1:21:140911:linux-kernel@vger.kernel.org::7867b2d47172e9d2f35242db9dd20a6:5c2d3daf1029d861
x-hashcash: 1:21:140911:kamezawa.hiroyu@jp.fujitsu.com::14a34d645a7fc01a68b8c6d3648ea2e1:1febf9ae83089b29
x-hashcash: 1:21:140911:hannes@cmpxchg.org::e7341e0b7a543b91ebce74c68e89da9d:84b2e6a3d67d2c8e
x-hashcash: 1:21:140911:mhocko@suse.cz::c3be8daf8b573f2fc916fb0a7a930138:b58d3ee4b847a7be
x-hashcash: 1:21:140911:gthelen@google.com::ddf304093b0c1bc2946b1ea8d98a8e2c:52880cffdab71ca4
x-hashcash: 1:21:140911:hughd@google.com::3d290a51a82eaad21989f2d9f285e9:caa4fd70985a7d9d
x-hashcash: 1:21:140911:Motohiro.Kosaki@us.fujitsu.com::e20c96998c0a28d2e905baf4654b8b62:3d52e7fed1b9fce
x-hashcash: 1:21:140911:glommer@gmail.com::9b6dfa6fe832d0989e8edf2115750d72:606ec818d3dad570
x-hashcash: 1:21:140911:tj@kernel.org::efbedea5caec46d2dcb6c2ff1a44a754:4956ee59d11a03ee
x-hashcash: 1:21:140911:akpm@linux-foundation.org::5016ef6eb49fe7891c64514486245b25:c6da15450e98b76e
x-hashcash: 1:21:140911:xemul@parallels.com::d33fc23a96f8b4d17e34f7d4d90961b1:ff6b7e04a3cfa7ac
x-hashcash: 1:21:140911:khorenko@parallels.com::7721b5cf8bc52c5aff684402c7382617:1763a86f9f092353
x-hashcash: 1:21:140911:linux-mm@kvack.org::ca4f7aa862d4f43eef78fdaf90da52e:5d8de1dc157ef3ef
x-hashcash: 1:21:140911:cgroups@vger.kernel.org::cf06604feb334a723a3a90898eb80c56:cb639498516ecd61
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000609080005020801020809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000609080005020801020809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-09-11 11:41, Vladimir Davydov wrote:
> Though hard memory limits suit perfectly for sand-boxing, they are not
> that efficient when it comes to partitioning a server's resources among=

> multiple containers. The point is a container consuming a particular
> amount of memory most of time may have infrequent spikes in the load.
> Setting the hard limit to the maximal possible usage (spike) will lower=

> server utilization while setting it to the "normal" usage will result i=
n
> heavy lags during the spikes.
>=20
> To handle such scenarios soft limits were introduced. The idea is to
> allow a container to breach the limit freely when there's enough free
> memory, but shrink it back to the limit aggressively on global memory
> pressure. However, the concept of soft limits is intrinsically unsafe
> by itself: if a container eats too much anonymous memory, it will be
> very slow or even impossible (if there's no swap) to reclaim its
> resources back to the limit. As a result the whole system will be
> feeling bad until it finally realizes the culprit must die.
I have actually seen this happen on a number of occasions.  I use
cgroups to sandbox anything I run under wine (cause it's gotten so good
at mimicking windows that a number of windows viruses will run on it),
and have had issues with wine processes with memory leaks bringing the
system to it's knees on occasion.  There are a lot of other stupid
programs out there too, I've seen stuff that does it's own caching, but
doesn't free any of the cached items until it either gets a failed
malloc() or the system starts swapping it out.
>=20
> Currently we have no way to react to anonymous memory + swap usage
> growth inside a container: the memsw counter accounts both anonymous
> memory and file caches and swap, so we have neither a limit for
> anon+swap nor a threshold notification. Actually, memsw is totally
> useless if one wants to make full use of soft limits: it should be set
> to a very large value or infinity then, otherwise it just makes no
> sense.
>=20
> That's one of the reasons why I think we should replace memsw with a
> kind of anonsw so that it'd account only anon+swap. This way we'd still=

> be able to sand-box apps, but it'd also allow us to avoid nasty
> surprises like the one I described above. For more arguments for and
> against this idea, please see the following thread:
>=20
> http://www.spinics.net/lists/linux-mm/msg78180.html
>=20
> There's an alternative to this approach backed by Kamezawa. He thinks
> that OOM on anon+swap limit hit is a no-go and proposes to use memory
> thresholds for it. I still strongly disagree with the proposal, because=

> it's unsafe (what if the userspace handler won't react in time?).
> Nevertheless, I implement his idea in this RFC. I hope this will fuel
> the debate, because sadly enough nobody seems to care about this
> problem.

So, I've actually been following the discussion mentioned above rather
closely, I just haven't had the time to comment on it.
Personally, I think both ideas have merits, but would like to propose a
third solution.

I would propose that we keep memsw like it is right now (because being
able to limit the sum of anon+cache+swap is useful, especially if you
are using cgroups to do strict partitioning of a machine), but give it a
better name (vss maybe?), add a separate counter for anonymous memory
and swap, and then provide for each of them an option to control whether
the OOM killer is used when the limit is hit (possibly with the option
of a delay before running the OOM killer), and a separate option for
threshold notifications.  Users than would be able to choose whether
they want a particular container killed when it hits a particular limit,
and whether or not they want notifications when it gets within a certain
percentage of the limit, or potentially both.

We still need to have a way to hard limit sum of anon+cache+swap (and
ideally kmem once that is working correctly), because that useful for
systems that have to provide guaranteed minimum amounts of virtual
memory to containers.


--------------ms000609080005020801020809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTExMTcyMDM0
WjAjBgkqhkiG9w0BCQQxFgQUPHIim/I1Bri2mtmLnmAebTwaQR4wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEApvJsx/WUDBKpYkXn9FaLggpOpWUB
sB36Ipc8d3jtAcwO2Sdfse+wL/o/jaJTDh8s86Plsg7qKPg/or0W/5RGaNWUbkOLZWspDU07
qiNT6FBpQ105O639xnzB4BtwpcBNdfpEDVM0cX+LsU/JqIlzYPZdKmNJfDwTDNN53XVhqOZ4
2UBYjD2yoEjiK++uuvYImNC37LUbeQ7EBsNGQx3yJl6qFuOsgwxtuBlGUp0DNgRY8Q4cfo8w
BQqwYCdU+v4GHhVANgyBTFcVvsDEI8/1BYTSN78ZefJdyPCI+EwQGjAJjgaeggwXHhNXnRMK
Mvpg0ggk1ZGhRxPYHMmg2as+rQAAAAAAAA==
--------------ms000609080005020801020809--
