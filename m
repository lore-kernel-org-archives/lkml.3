Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3BLV1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:27:43 -0500
Received: from p02c11o145.mxlogic.net ([208.65.144.78]:39381 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3BLV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:27:41 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 16:27:40 EST
X-MXL-Hash: 511ab3cc5a3dc0b7-751d43564178f0baf3176b818fd1bdfa9216bee8
X-MXL-Hash: 511ab1aa3405a31a-72faf55266994a39040306b6dc2b755ad7aa4bb6
From: Peter Staubach <pstaubach@exagrid.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Date: Tue, 12 Feb 2013 16:18:31 -0500
Subject: RE: [PATCH 0/2] NFSD: fix races in service per-net resources
 allocation
Thread-Topic: [PATCH 0/2] NFSD: fix races in service per-net resources
 allocation
Thread-Index: Ac4JYuPUn/aQAwXNROqHb8o+hG4cswAA3Clw
Message-ID: <FA8A9A935BFD3A4D8F0CDA1C4F611BCC0C5DF98826@IT-1874.Isys.com>
References: <20130201111046.24066.72836.stgit@localhost.localdomain>
 <20130211002558.GD10161@fieldses.org> <51188D2A.4070605@parallels.com>
 <20130211163715.GA19342@fieldses.org> <20130211205845.GE30117@fieldses.org>
 <511A10E0.1000604@parallels.com> <20130212204533.GD10267@fieldses.org>
In-Reply-To: <20130212204533.GD10267@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-AnalysisOut: [v=2.0 cv=DvjhDhD+ c=1 sm=1 a=YmXeKoonWU0GTmr6cORa5w==:17 a]
X-AnalysisOut: [=q4Ya75L3XVYA:10 a=ooaBVg03rvgA:10 a=BLceEmwcHowA:10 a=Ikc]
X-AnalysisOut: [TkHD0fZMA:10 a=ZC8462-RAAAA:8 a=_njUq414AAAA:8 a=n8MwpcLru]
X-AnalysisOut: [DUA:10 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=JDjsHSkAAAAA:8 ]
X-AnalysisOut: [a=6rqHouBjAAAA:8 a=tmtSDGaQAAAA:8 a=uWX2rnlTJG6ITGXdXjAA:9]
X-AnalysisOut: [ a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=jbrJJM5MRmoA:10 a=H]
X-AnalysisOut: [f6muOzgCGQA:10 a=TAmEwCHjoHMA:10 a=jkObVMfX7fAA:10 a=iC6Xe]
X-AnalysisOut: [OWePBJ6zjj7:21 a=L79W4CwgoLxjvJxA:21]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010122901)]
X-MAIL-FROM: <pstaubach@exagrid.com>
X-SOURCE-IP: [69.84.133.248]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1CLRhU2026098

The "+" thing seems a little odd.  Why not use "||" instead?  The sum of the two returns isn't really the important thing, is it?  It is that either call to svc_close_list() returns non-zero.

	Thanx...

		ps


-----Original Message-----
From: linux-nfs-owner@vger.kernel.org [mailto:linux-nfs-owner@vger.kernel.org] On Behalf Of J. Bruce Fields
Sent: Tuesday, February 12, 2013 3:46 PM
To: Stanislav Kinsbursky
Cc: akpm@linux-foundation.org; linux-nfs@vger.kernel.org; Trond.Myklebust@netapp.com; linux-kernel@vger.kernel.org; devel@openvz.org
Subject: Re: [PATCH 0/2] NFSD: fix races in service per-net resources allocation

On Tue, Feb 12, 2013 at 01:52:32PM +0400, Stanislav Kinsbursky wrote:
> 12.02.2013 00:58, J. Bruce Fields Ğ¿Ğ¸ÑˆĞµÑ‚:
> <snip>
> >  void svc_close_net(struct svc_serv *serv, struct net *net)
> >  {
> >-	svc_close_list(serv, &serv->sv_tempsocks, net);
> >-	svc_close_list(serv, &serv->sv_permsocks, net);
> >-
> >-	svc_clear_pools(serv, net);
> >-	/*
> >-	 * At this point the sp_sockets lists will stay empty, since
> >-	 * svc_xprt_enqueue will not add new entries without taking the
> >-	 * sp_lock and checking XPT_BUSY.
> >-	 */
> >-	svc_clear_list(serv, &serv->sv_tempsocks, net);
> >-	svc_clear_list(serv, &serv->sv_permsocks, net);
> >+	int closed;
> >+	int delay = 0;
> >+
> >+again:
> >+	closed = svc_close_list(serv, &serv->sv_permsocks, net);
> >+	closed += svc_close_list(serv, &serv->sv_tempsocks, net);
> >+	if (closed) {
> >+		svc_clean_up_xprts(serv, net);
> >+		msleep(delay++);
> >+		goto again;
> >+	}
> 
> Frankly, this hunk above makes me feel sick... :( But I have no better 
> idea right now...
> Maybe make this hunk a bit less weird (this is from my POW only, of course), like this:
> 
> > +	while (svc_close_list(serv, &serv->sv_permsocks, net) +
> > +	       svc_close_list(serv, &serv->sv_tempsocks, net)) {
> > +		svc_clean_up_xprts(serv, net);
> > +		msleep(delay++);
> > +	}
> 
> ?

OK, that's a little more compact at least.

--b.

> 
> Anyway, thanks!
> 
> Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> --
> Best regards,
> Stanislav Kinsbursky
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
