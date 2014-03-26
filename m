Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaCZRqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:46:11 -0400
Received: from smtp.eu.citrix.com ([185.25.65.24]:8610 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaCZRqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:46:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,736,1389744000"; 
   d="scan'208";a="12495600"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Wei Liu <wei.liu2@citrix.com>, annie li <annie.li@oracle.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Xen-devel] Xen-unstable Linux 3.14-rc3 and 3.13 Network
 troubles "bisected"
Thread-Topic: [Xen-devel] Xen-unstable Linux 3.14-rc3 and 3.13 Network
 troubles "bisected"
Thread-Index: AQHPPLStn4Kkhyz980uf2acSGT8Sr5rbnK8AgAAk2gCAAAHLgIAABk6AgAAreQCAAKlwgIAApZYAgAACxACAAAVwAIAAJs0AgAAG8ACAAABfAIAAAqeAgAAAwACAAAC9gIAABFKAgAAG+oCAABF0gIAHc7MAgADIlACAAOKDgIAANyqAgAAL8QCAAEXOAIAAEiWAgAAfUQCAANABAIAAn+gAgALcmwCAAAp5gIABo2gAgASBGICAAAPtAIABSiEAgABKIvD///whgIAAEfEw///6VYCAABUwwP//9/8AAAJggWD///fwAP//68nw
Date: Wed, 26 Mar 2014 17:46:06 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD029B350@AMSPEX01CL01.citrite.net>
References: <1744594108.20140318162127@eikelenboom.it>
 <20140318160412.GB16807@zion.uk.xensource.com>
 <1701035622.20140318211402@eikelenboom.it>
 <722971844.20140318221859@eikelenboom.it>
 <1688396550.20140319001104@eikelenboom.it>
 <20140319113532.GD16807@zion.uk.xensource.com>
 <246793256.20140319220752@eikelenboom.it>
 <20140321164958.GA31766@zion.uk.xensource.com>
 <1334202265.20140321182727@eikelenboom.it>
 <1056661597.20140322192834@eikelenboom.it>
 <20140325151539.GG31766@zion.uk.xensource.com>
 <79975567.20140325162942@eikelenboom.it>
 <1972209744.20140326121116@eikelenboom.it>
 <9AAE0902D5BC7E449B7C8E4E778ABCD029AD94@AMSPEX01CL01.citrite.net>
 <1715463578.20140326162245@eikelenboom.it>
 <9AAE0902D5BC7E449B7C8E4E778ABCD029AFC1@AMSPEX01CL01.citrite.net>
 <799579453.20140326170641@eikelenboom.it>
 <9AAE0902D5BC7E449B7C8E4E778ABCD029B106@AMSPEX01CL01.citrite.net>
 <789809468.20140326175352@eikelenboom.it>
 <9AAE0902D5BC7E449B7C8E4E778ABCD029B277@AMSPEX01CL01.citrite.net>
 <966386043.20140326183304@eikelenboom.it>
In-Reply-To: <966386043.20140326183304@eikelenboom.it>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-send shortened version...

> -----Original Message-----
> From: Sander Eikelenboom [mailto:linux@eikelenboom.it]
> Sent: 26 March 2014 16:54
> To: Paul Durrant
> Cc: Wei Liu; annie li; Zoltan Kiss; xen-devel@lists.xen.org; Ian Campbell; linux-
> kernel; netdev@vger.kernel.org
> Subject: Re: [Xen-devel] Xen-unstable Linux 3.14-rc3 and 3.13 Network
> troubles "bisected"
> 
[snip]
> >>
> >> - When processing an SKB we end up in "xenvif_gop_frag_copy" while
> prod
> >> == cons ... but we still have bytes and size left ..
> >> - start_new_rx_buffer() has returned true ..
> >> - so we end up in get_next_rx_buffer
> >> - this does a RING_GET_REQUEST and ups cons ..
> >> - and we end up with a bad grant reference.
> >>
> >> Sometimes we are saved by the bell .. since additional slots have become
> >> free (you see cons become > prod in "get_next_rx_buffer" but shortly
> after
> >> that prod is increased ..
> >> just in time to not cause a overrun).
> >>
> 
> > Ah, but hang on... There's a BUG_ON meta_slots_used >
> max_slots_needed, so if we are overflowing the worst-case calculation then
> why is that BUG_ON not firing?
> 
> You mean:
>                 sco = (struct skb_cb_overlay *)skb->cb;
>                 sco->meta_slots_used = xenvif_gop_skb(skb, &npo);
>                 BUG_ON(sco->meta_slots_used > max_slots_needed);
> 
> in "get_next_rx_buffer" ?
> 

That code excerpt is from net_rx_action(),isn't it?

> I don't know .. at least now it doesn't crash dom0 and therefore not my
> complete machine and since tcp is recovering from a failed packet  :-)
> 

Well, if the code calculating max_slots_needed were underestimating then the BUG_ON() should fire. If it is not firing in your case then this suggests your problem lies elsewhere, or that meta_slots_used is not equal to the number of ring slots consumed.

> But probably because "npo->copy_prod++" seems to be used for the frags ..
> and it isn't added to  npo->meta_prod ?
> 

meta_slots_used is calculated as the value of meta_prod at return (from xenvif_gop_skb()) minus the value on entry , and if you look back up the code then you can see that meta_prod is incremented every time RING_GET_REQUEST() is evaluated. So, we must be consuming a slot without evaluating RING_GET_REQUEST() and I think that's exactly what's happening... Right at the bottom of xenvif_gop_frag_copy() req_cons is simply incremented in the case of a GSO. So the BUG_ON() is indeed off by one.

  Paul

