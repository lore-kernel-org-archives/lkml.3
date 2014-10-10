Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaJJOnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:43:11 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34154 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaJJOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:43:09 -0400
Date: Fri, 10 Oct 2014 22:42:51 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141010144248.GA5107@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141008142437.GA9912@localhost.localdomain>
 <20141008171034.1506550f@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008171034.1506550f@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 05:10:34PM +0200, Boris Brezillon wrote:
> On Wed, 8 Oct 2014 22:24:40 +0800
> Huang Shijie <shijie8@gmail.com> wrote:
> 
> > On Tue, Sep 23, 2014 at 04:07:33PM +0200, Boris BREZILLON wrote:
> > > Hello Huang, Brian,
> > > 
> > > This is just a new proposal to support raw accesses in a more standard way
> > > in the GPMI driver.
> > > This series has been tested on an imx28 board.
> > > 
> > > Any suggestions are welcome.
> > > 
> > > Best Regards,
> > > 
> > > Boris
> > > 
> > > Changes since v2:
> > >  - fixed a bug in gpmi_move_bits
> > >  - add a raw_buffer field to be used when using raw access methods
> > >    (experienced memory corruptions when directly using page_buffer_virt
> > >    buffer)
> > >  - add raw OOB access functions
> > 
> > I tested this patch set today with the imx6dl-sabreauto board.
> > 
> >     NAND: Micron MT29F64G08CBABAWP
> > 	8192MiB, MLC, page size: 8192, OOB size: 744
> > 
> >     ECC: 40bit
> > 
> > The result:
> > 
> > [ 3672.779009] ==================================================
> > [ 3672.784974] mtd_nandbiterrs: MTD device: 0
> > [ 3672.789480] mtd_nandbiterrs: MTD device size 16777216, eraseblock=2097152, page=8192, oob=744
> > [ 3672.798169] mtd_nandbiterrs: Device uses 1 subpages of 8192 bytes
> > [ 3672.804554] mtd_nandbiterrs: Using page=0, offset=0, eraseblock=0
> > [ 3672.812497] mtd_nandbiterrs: incremental biterrors test
> > [ 3672.818688] mtd_nandbiterrs: write_page
> > [ 3672.825529] mtd_nandbiterrs: rewrite page
> > [ 3672.837290] mtd_nandbiterrs: read_page
> > [ 3672.848407] mtd_nandbiterrs: error: read failed at 0x0
> > [ 3672.853644] mtd_nandbiterrs: After 0 biterrors per subpage, read reported error -74
> > [ 3672.862932] mtd_nandbiterrs: finished successfully.
> > [ 3672.867837] ==================================================
> > 
> > [ 3745.282368] ==================================================
> > [ 3745.288227] mtd_nandbiterrs: MTD device: 0
> > [ 3745.292913] mtd_nandbiterrs: MTD device size 16777216, eraseblock=2097152, page=8192, oob=744
> > [ 3745.301897] mtd_nandbiterrs: Device uses 1 subpages of 8192 bytes
> > [ 3745.308023] mtd_nandbiterrs: Using page=1, offset=8192, eraseblock=0
> > [ 3745.316778] mtd_nandbiterrs: incremental biterrors test
> > [ 3745.323017] mtd_nandbiterrs: write_page
> > [ 3745.328616] mtd_nandbiterrs: rewrite page
> > [ 3745.334191] mtd_nandbiterrs: read_page
> > [ 3745.346878] mtd_nandbiterrs: error: read failed at 0x2000
> > [ 3745.352352] mtd_nandbiterrs: After 0 biterrors per subpage, read reported error -74
> > [ 3745.361281] mtd_nandbiterrs: finished successfully.
> > [ 3745.366173] ==================================================
> > 
> > 
> > Is this okay?
> 
> No, it doesn't seem to be correct.
> But it's an MLC flash, so you'll most probably need to apply this patch
> to nandbiterrs testsuite:
> 
> http://code.bulix.org/f69wuu-87021
> 
> This patch is flashing the block between each bitflip insertion to
> avoid multiple write without erasure (which, AFAIK, is not supported
> by MLC flashes).
After I applied this patch. It seems ok now.

The test result:
[  244.789900] ==================================================
[  244.795826] mtd_nandbiterrs: MTD device: 1
[  244.799974] mtd_nandbiterrs: MTD device size 16777216, eraseblock=2097152, page=8192, oob=744
[  244.808563] mtd_nandbiterrs: Device uses 1 subpages of 8192 bytes
[  244.814697] mtd_nandbiterrs: Using page=0, offset=0, eraseblock=0
[  244.822622] mtd_nandbiterrs: incremental biterrors test
[  244.828146] mtd_nandbiterrs: write_page
[  244.833341] mtd_nandbiterrs: fill page
[  244.838831] mtd_nandbiterrs: rewrite page
[  244.844353] mtd_nandbiterrs: read_page
[  244.848585] mtd_nandbiterrs: verify_page
[  244.852915] mtd_nandbiterrs: Successfully corrected 0 bit errors per subpage
[  244.859973] mtd_nandbiterrs: Inserted biterror @ 0/5
[  244.866316] mtd_nandbiterrs: rewrite page
[  244.871629] mtd_nandbiterrs: read_page
[  244.875864] mtd_nandbiterrs: verify_page
[  244.880161] mtd_nandbiterrs: Successfully corrected 1 bit errors per subpage
[  244.887247] mtd_nandbiterrs: Inserted biterror @ 0/2
[  244.893499] mtd_nandbiterrs: rewrite page
[  244.898766] mtd_nandbiterrs: read_page
[  244.903071] mtd_nandbiterrs: verify_page
[  244.907369] mtd_nandbiterrs: Successfully corrected 2 bit errors per subpage
[  244.914463] mtd_nandbiterrs: Inserted biterror @ 0/0
[  244.920701] mtd_nandbiterrs: rewrite page
[  244.926109] mtd_nandbiterrs: read_page
[  244.930343] mtd_nandbiterrs: verify_page
[  244.934672] mtd_nandbiterrs: Successfully corrected 3 bit errors per subpage
[  244.941752] mtd_nandbiterrs: Inserted biterror @ 1/7
[  244.947988] mtd_nandbiterrs: rewrite page
[  244.953408] mtd_nandbiterrs: read_page
[  244.957641] mtd_nandbiterrs: verify_page
[  244.961970] mtd_nandbiterrs: Successfully corrected 4 bit errors per subpage
[  244.969029] mtd_nandbiterrs: Inserted biterror @ 1/5
[  244.975357] mtd_nandbiterrs: rewrite page
[  244.980627] mtd_nandbiterrs: read_page
[  244.984931] mtd_nandbiterrs: verify_page
[  244.989229] mtd_nandbiterrs: Successfully corrected 5 bit errors per subpage
[  244.996318] mtd_nandbiterrs: Inserted biterror @ 1/2
[  245.002576] mtd_nandbiterrs: rewrite page
[  245.007843] mtd_nandbiterrs: read_page
[  245.012139] mtd_nandbiterrs: verify_page
[  245.016439] mtd_nandbiterrs: Successfully corrected 6 bit errors per subpage
[  245.023526] mtd_nandbiterrs: Inserted biterror @ 1/0
[  245.029755] mtd_nandbiterrs: rewrite page
[  245.035149] mtd_nandbiterrs: read_page
[  245.039378] mtd_nandbiterrs: verify_page
[  245.043726] mtd_nandbiterrs: Successfully corrected 7 bit errors per subpage
[  245.050787] mtd_nandbiterrs: Inserted biterror @ 2/6
[  245.057123] mtd_nandbiterrs: rewrite page
[  245.062423] mtd_nandbiterrs: read_page
[  245.066654] mtd_nandbiterrs: verify_page
[  245.071001] mtd_nandbiterrs: Successfully corrected 8 bit errors per subpage
[  245.078060] mtd_nandbiterrs: Inserted biterror @ 2/5
[  245.084398] mtd_nandbiterrs: rewrite page
[  245.089673] mtd_nandbiterrs: read_page
[  245.093978] mtd_nandbiterrs: verify_page
[  245.098275] mtd_nandbiterrs: Successfully corrected 9 bit errors per subpage
[  245.105360] mtd_nandbiterrs: Inserted biterror @ 2/2
[  245.111622] mtd_nandbiterrs: rewrite page
[  245.116899] mtd_nandbiterrs: read_page
[  245.121188] mtd_nandbiterrs: verify_page
[  245.125485] mtd_nandbiterrs: Successfully corrected 10 bit errors per subpage
[  245.132658] mtd_nandbiterrs: Inserted biterror @ 2/0
[  245.138895] mtd_nandbiterrs: rewrite page
[  245.144294] mtd_nandbiterrs: read_page
[  245.148524] mtd_nandbiterrs: verify_page
[  245.152853] mtd_nandbiterrs: Successfully corrected 11 bit errors per subpage
[  245.159998] mtd_nandbiterrs: Inserted biterror @ 3/7
[  245.166326] mtd_nandbiterrs: rewrite page
[  245.171620] mtd_nandbiterrs: read_page
[  245.175849] mtd_nandbiterrs: verify_page
[  245.180146] mtd_nandbiterrs: Successfully corrected 12 bit errors per subpage
[  245.187314] mtd_nandbiterrs: Inserted biterror @ 3/6
[  245.193603] mtd_nandbiterrs: rewrite page
[  245.198874] mtd_nandbiterrs: read_page
[  245.203183] mtd_nandbiterrs: verify_page
[  245.207480] mtd_nandbiterrs: Successfully corrected 13 bit errors per subpage
[  245.214657] mtd_nandbiterrs: Inserted biterror @ 3/5
[  245.220958] mtd_nandbiterrs: rewrite page
[  245.226235] mtd_nandbiterrs: read_page
[  245.230462] mtd_nandbiterrs: verify_page
[  245.234787] mtd_nandbiterrs: Successfully corrected 14 bit errors per subpage
[  245.241965] mtd_nandbiterrs: Inserted biterror @ 3/2
[  245.248210] mtd_nandbiterrs: rewrite page
[  245.253614] mtd_nandbiterrs: read_page
[  245.257846] mtd_nandbiterrs: verify_page
[  245.262177] mtd_nandbiterrs: Successfully corrected 15 bit errors per subpage
[  245.269322] mtd_nandbiterrs: Inserted biterror @ 3/0
[  245.275670] mtd_nandbiterrs: rewrite page
[  245.280965] mtd_nandbiterrs: read_page
[  245.285202] mtd_nandbiterrs: verify_page
[  245.289501] mtd_nandbiterrs: Successfully corrected 16 bit errors per subpage
[  245.296677] mtd_nandbiterrs: Inserted biterror @ 4/2
[  245.302952] mtd_nandbiterrs: rewrite page
[  245.308237] mtd_nandbiterrs: read_page
[  245.312548] mtd_nandbiterrs: verify_page
[  245.316846] mtd_nandbiterrs: Successfully corrected 17 bit errors per subpage
[  245.324018] mtd_nandbiterrs: Inserted biterror @ 4/0
[  245.330264] mtd_nandbiterrs: rewrite page
[  245.335672] mtd_nandbiterrs: read_page
[  245.339895] mtd_nandbiterrs: verify_page
[  245.344222] mtd_nandbiterrs: Successfully corrected 18 bit errors per subpage
[  245.351399] mtd_nandbiterrs: Inserted biterror @ 5/7
[  245.357673] mtd_nandbiterrs: rewrite page
[  245.363085] mtd_nandbiterrs: read_page
[  245.367316] mtd_nandbiterrs: verify_page
[  245.371646] mtd_nandbiterrs: Successfully corrected 19 bit errors per subpage
[  245.378792] mtd_nandbiterrs: Inserted biterror @ 5/2
[  245.385136] mtd_nandbiterrs: rewrite page
[  245.390402] mtd_nandbiterrs: read_page
[  245.394704] mtd_nandbiterrs: verify_page
[  245.399002] mtd_nandbiterrs: Successfully corrected 20 bit errors per subpage
[  245.406178] mtd_nandbiterrs: Inserted biterror @ 5/0
[  245.412440] mtd_nandbiterrs: rewrite page
[  245.417711] mtd_nandbiterrs: read_page
[  245.422027] mtd_nandbiterrs: verify_page
[  245.426326] mtd_nandbiterrs: Successfully corrected 21 bit errors per subpage
[  245.433515] mtd_nandbiterrs: Inserted biterror @ 6/6
[  245.439795] mtd_nandbiterrs: rewrite page
[  245.445203] mtd_nandbiterrs: read_page
[  245.449432] mtd_nandbiterrs: verify_page
[  245.453762] mtd_nandbiterrs: Successfully corrected 22 bit errors per subpage
[  245.460927] mtd_nandbiterrs: Inserted biterror @ 6/2
[  245.467160] mtd_nandbiterrs: rewrite page
[  245.472558] mtd_nandbiterrs: read_page
[  245.476788] mtd_nandbiterrs: verify_page
[  245.481133] mtd_nandbiterrs: Successfully corrected 23 bit errors per subpage
[  245.488279] mtd_nandbiterrs: Inserted biterror @ 6/0
[  245.494610] mtd_nandbiterrs: rewrite page
[  245.499888] mtd_nandbiterrs: read_page
[  245.504194] mtd_nandbiterrs: verify_page
[  245.508490] mtd_nandbiterrs: Successfully corrected 24 bit errors per subpage
[  245.515676] mtd_nandbiterrs: Inserted biterror @ 7/7
[  245.522001] mtd_nandbiterrs: rewrite page
[  245.527275] mtd_nandbiterrs: read_page
[  245.531577] mtd_nandbiterrs: verify_page
[  245.535874] mtd_nandbiterrs: Successfully corrected 25 bit errors per subpage
[  245.543049] mtd_nandbiterrs: Inserted biterror @ 7/6
[  245.549291] mtd_nandbiterrs: rewrite page
[  245.554685] mtd_nandbiterrs: read_page
[  245.558916] mtd_nandbiterrs: verify_page
[  245.563252] mtd_nandbiterrs: Successfully corrected 26 bit errors per subpage
[  245.570397] mtd_nandbiterrs: Inserted biterror @ 7/2
[  245.576733] mtd_nandbiterrs: rewrite page
[  245.582124] mtd_nandbiterrs: read_page
[  245.586355] mtd_nandbiterrs: verify_page
[  245.590650] mtd_nandbiterrs: Successfully corrected 27 bit errors per subpage
[  245.597836] mtd_nandbiterrs: Inserted biterror @ 7/0
[  245.604124] mtd_nandbiterrs: rewrite page
[  245.609392] mtd_nandbiterrs: read_page
[  245.613704] mtd_nandbiterrs: verify_page
[  245.618005] mtd_nandbiterrs: Successfully corrected 28 bit errors per subpage
[  245.625179] mtd_nandbiterrs: Inserted biterror @ 8/7
[  245.631417] mtd_nandbiterrs: rewrite page
[  245.636685] mtd_nandbiterrs: read_page
[  245.641007] mtd_nandbiterrs: verify_page
[  245.645308] mtd_nandbiterrs: Successfully corrected 29 bit errors per subpage
[  245.652482] mtd_nandbiterrs: Inserted biterror @ 8/5
[  245.658726] mtd_nandbiterrs: rewrite page
[  245.664125] mtd_nandbiterrs: read_page
[  245.668355] mtd_nandbiterrs: verify_page
[  245.672697] mtd_nandbiterrs: Successfully corrected 30 bit errors per subpage
[  245.679842] mtd_nandbiterrs: Inserted biterror @ 8/4
[  245.686178] mtd_nandbiterrs: rewrite page
[  245.691492] mtd_nandbiterrs: read_page
[  245.695722] mtd_nandbiterrs: verify_page
[  245.700019] mtd_nandbiterrs: Successfully corrected 31 bit errors per subpage
[  245.707193] mtd_nandbiterrs: Inserted biterror @ 8/2
[  245.713444] mtd_nandbiterrs: rewrite page
[  245.718720] mtd_nandbiterrs: read_page
[  245.723022] mtd_nandbiterrs: verify_page
[  245.727319] mtd_nandbiterrs: Successfully corrected 32 bit errors per subpage
[  245.734489] mtd_nandbiterrs: Inserted biterror @ 8/0
[  245.740728] mtd_nandbiterrs: rewrite page
[  245.746126] mtd_nandbiterrs: read_page
[  245.750356] mtd_nandbiterrs: verify_page
[  245.754694] mtd_nandbiterrs: Successfully corrected 33 bit errors per subpage
[  245.761861] mtd_nandbiterrs: Inserted biterror @ 9/5
[  245.768127] mtd_nandbiterrs: rewrite page
[  245.773537] mtd_nandbiterrs: read_page
[  245.777776] mtd_nandbiterrs: verify_page
[  245.782109] mtd_nandbiterrs: Successfully corrected 34 bit errors per subpage
[  245.789253] mtd_nandbiterrs: Inserted biterror @ 9/4
[  245.795584] mtd_nandbiterrs: rewrite page
[  245.800900] mtd_nandbiterrs: read_page
[  245.805137] mtd_nandbiterrs: verify_page
[  245.809434] mtd_nandbiterrs: Successfully corrected 35 bit errors per subpage
[  245.816606] mtd_nandbiterrs: Inserted biterror @ 9/2
[  245.822860] mtd_nandbiterrs: rewrite page
[  245.828129] mtd_nandbiterrs: read_page
[  245.832428] mtd_nandbiterrs: verify_page
[  245.836727] mtd_nandbiterrs: Successfully corrected 36 bit errors per subpage
[  245.843914] mtd_nandbiterrs: Inserted biterror @ 9/0
[  245.850158] mtd_nandbiterrs: rewrite page
[  245.855565] mtd_nandbiterrs: read_page
[  245.859799] mtd_nandbiterrs: verify_page
[  245.864127] mtd_nandbiterrs: Successfully corrected 37 bit errors per subpage
[  245.871294] mtd_nandbiterrs: Inserted biterror @ 10/7
[  245.877618] mtd_nandbiterrs: rewrite page
[  245.883018] mtd_nandbiterrs: read_page
[  245.887249] mtd_nandbiterrs: verify_page
[  245.891575] mtd_nandbiterrs: Successfully corrected 38 bit errors per subpage
[  245.898721] mtd_nandbiterrs: Inserted biterror @ 10/6
[  245.905141] mtd_nandbiterrs: rewrite page
[  245.910420] mtd_nandbiterrs: read_page
[  245.914738] mtd_nandbiterrs: verify_page
[  245.919035] mtd_nandbiterrs: Successfully corrected 39 bit errors per subpage
[  245.926210] mtd_nandbiterrs: Inserted biterror @ 10/5
[  245.932549] mtd_nandbiterrs: rewrite page
[  245.937820] mtd_nandbiterrs: read_page
[  245.942120] mtd_nandbiterrs: Read reported 40 corrected bit errors
[  245.948311] mtd_nandbiterrs: verify_page
[  245.952639] mtd_nandbiterrs: Successfully corrected 40 bit errors per subpage
[  245.959784] mtd_nandbiterrs: Inserted biterror @ 10/4
[  245.966204] mtd_nandbiterrs: rewrite page
[  245.971508] mtd_nandbiterrs: read_page
[  245.981085] mtd_nandbiterrs: error: fill page failed at 0x0 err = -74
[  245.987538] mtd_nandbiterrs: After 41 biterrors per subpage, read reported error -74
[  245.996662] mtd_nandbiterrs: finished successfully.
[  246.001578] ==================================================

I think you can send out the new version.

thanks
Huang Shijie
