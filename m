Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaGKNnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:43:33 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33338 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaGKNnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:43:31 -0400
In-Reply-To: <20140616142812.GB19387@thunk.org>
References: <20140527134645.GD14099@lst.de> <20140527141144.GE14099@lst.de> <53990165.3070505@zytor.com> <20140612100954.GA26943@lst.de> <20140614024050.GA6447@thunk.org> <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com> <20140615051146.GA2180@thunk.org> <20140616073108.GA28232@suse.de> <20140616112207.GB4887@thunk.org> <20140616141444.GB1744@suse.de> <20140616142812.GB19387@thunk.org>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
X-KeepSent: 8E5D9F84:46724386-C1257D12:00431C2E;
 type=4; name=$KeepSent
To: "Theodore Ts'o" <tytso@mit.edu>, Torsten Duwe <duwe@suse.de>
Cc: linux-kernel@vger.kernel.org, geralds@linux.vnet.ibm.com,
        heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <FREUDE@de.ibm.com>
X-Mailer: Lotus Notes Release 8.5.3FP5 Septem 15, 2011
Message-ID: <OF8E5D9F84.46724386-ONC1257D12.00431C2E-C1257D12.004B5DCC@de.ibm.com>
From: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Date: Fri, 11 Jul 2014 15:43:24 +0200
X-MIMETrack: Serialize by Router on D06ML044/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 11/07/2014 15:43:25
MIME-Version: 1.0
Content-type: multipart/mixed; 
	Boundary="0__=4EBBF781DFD09ABE8f9e8a93df938690918c4EBBF781DFD09ABE"
Content-Disposition: inline
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071113-4966-0000-0000-000000B21FE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0__=4EBBF781DFD09ABE8f9e8a93df938690918c4EBBF781DFD09ABE
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: quoted-printable


Hi @all,

First, sorry for the late feedback, I was busy with other topics.

In the meanwhile I had a look at this hwrng entropy feature related to =
s390
and the zcrypt hardware random generator.
I have a concern about the initial call to the hwrng device while tryin=
g to
register the same.

drivers/char/hw_random/core.c
...
int hwrng_register(struct hwrng *rng) {
   ...
   bytes_read =3D rng_get_data(rng, bytes, sizeof(bytes), 1);
        if (bytes_read > 0)
                add_device_randomness(bytes, bytes_read);
  ...
}

At this point in time the zcrypt hw device is not registered completely=
 in
the internal zcrypt device list (ap_device_list). The crypto card itsel=
f is
initialized and ready to receive and service requests, but the tasklet =
that
retrieve the card response is not able to find the device because it's =
not
yet in the list. Finally the response would not be received and the thr=
ead
is still waiting for completion, hence the probing/registering procedur=
e
for all the other crypto devices is blocked. No further devices could b=
e
scanned, initialized and registered.
Therefore I would not recommend to trigger a hw device request before t=
he
device register process has completed.

Anyway, when the kernel thread (hwrng_fillfn) starts, it take care abou=
t
the initial call to the zcrypt rng device to be triggered. Therefore I
don't see any reason to manually call rng_get_data() during the
registration or did I missed something?

Mit freundlichen Gr=FC=DFen / Kind regards

Ingo Tuchscherer

Software Development - Linux on System z
IBM Systems &Technology Group
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
 Phone:            +49-7031-16-1986                 IBM Deutschland    =
                      (Embedded 
                                                                       =
                    image moved 
                                                                       =
                       to file: 
                                                                       =
                  pic60502.gif) 
                                                                       =
                                
 E-Mail:           ingo.tuchscherer@de.ibm.com      Schoenaicher Str. 2=
20                              
                                                                       =
                                
                                                    71032 Boeblingen   =
                                
                                                                       =
                                
                                                    Germany            =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
 IBM Deutschland                                                       =
                                
 Research &                                                            =
                                
 Development                                                           =
                                
 GmbH /                                                                =
                                
 Vorsitzender des                                                      =
                                
 Aufsichtsrats:                                                        =
                                
 Martina Koederitz                                                     =
                                
                                                                       =
                                
 Gesch=E4ftsf=FChrung:                                                 =
                                    
 Dirk Wittkopp                                                         =
                                
 Sitz der                                                              =
                                
 Gesellschaft:                                                         =
                                
 B=F6blingen /                                                         =
                                  
 Registergericht:                                                      =
                                
 Amtsgericht                                                           =
                                
 Stuttgart, HRB                                                        =
                                
 243294                                                                =
                                
                                                                       =
                                





From:	"Theodore Ts'o" <tytso@mit.edu>
To:	Torsten Duwe <duwe@suse.de>,
Cc:	Ingo Tuchscherer/Germany/IBM@IBMDE, Hans-Georg
            Markgraf/Germany/IBM@IBMDE, geralds@linux.vnet.ibm.com,
            mschwid2@linux.vnet.ibm.com, heicars2@linux.vnet.ibm.com, J=
=F6rn
            Engel <joern@logfs.org>
Date:	16.06.2014 16:28
Subject:	Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device



On Mon, Jun 16, 2014 at 04:14:44PM +0200, Torsten Duwe wrote:
> Also, I added the patch below to our kernel. Who wants to take that
> one-liner upstream?

This will require sucking in the "master" branch of random.git.  So
either the s390 tree can merge in the master branch, or I can carry it
in the random.git tree.  I'm happy to do that unless their are any
objections.

(Note: if you want to base something on random.git, please use the
master branch.  The dev branch is sometimes rewound...  I've since
moved master up to the dev branch, which is my guarantee not to rewind
anything up to the master branch.)

> --- linux-3.12-SLE12/drivers/s390/crypto/zcrypt_api.c.orig
2014-06-16 14:23:27.726162185 +0200
> +++ linux-3.12-SLE12/drivers/s390/crypto/zcrypt_api.c
2014-06-16 14:46:31.869103924 +0200
> @@ -1374,6 +1374,7 @@ static int zcrypt_rng_data_read(struct h
>  static struct hwrng zcrypt_rng_dev =3D {
>  		 .name		 		 =3D "zcrypt",
>  		 .data_read		 =3D zcrypt_rng_data_read,
> +		 .quality		 =3D 990,
>  };
>
>  static int zcrypt_rng_device_add(void)

I assume the z-Series RNG is presumed to be high quality, yes?

  		      		       		      		       -
Ted

=

--0__=4EBBF781DFD09ABE8f9e8a93df938690918c4EBBF781DFD09ABE
Content-type: image/gif; 
	name="pic60502.gif"
Content-Disposition: attachment; filename="pic60502.gif"
Content-transfer-encoding: base64

R0lGODlhVwAeAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8ER3u8bGxv///wAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAP/78KCgpICAgP8AAAD/AP//AAAA//8A/wD//////yH5BAAAAAAALAAAAABXAB4A
hwAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8ER3u8bGxv///wAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/7
8KCgpICAgP8AAAD/AP//AAAA//8A/wD//////wj+ABcoGEiwYMEFDAQaXGhwAUIGEBMyLBixIsSJ
By1qVIiRIEKOHRc+hAiS4ciKJU1qXMmypcuXMGPKnEmzps2bLlNO/Biy40OdBlf2VHByJVCREoeq
TOrT4tGMOKNKnUq1qtWrDBjmDIoSacWOFpve1NqypNOFGsUyXYq1rdu3cOO2JMvyKdq0Te0WnUnX
qFKiQkUebOhVruHDiBPD7Lvx796sDddmLFyT8dm/gaFOvBhZsefPoN9a7kqRdOmvnVNGpExzdESz
pj2G7QxZNmeooXPr3o1aAUmlPP/ePToSZG+2F1dLxhhcuG3ivU+qzZpVIHXecH0PTI5dNHXtdmUZ
h9/5mnnXotOvUx8PmP3Bk9C/4iU/2zeDgAA7

--0__=4EBBF781DFD09ABE8f9e8a93df938690918c4EBBF781DFD09ABE--

