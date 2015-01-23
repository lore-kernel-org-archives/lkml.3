Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbbAWKca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:32:30 -0500
Received: from mail-db3on0058.outbound.protection.outlook.com ([157.55.234.58]:29425
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbbAWKcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:32:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <20150123060734.GA7949@Darwish.PC>
CC: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux>
 <20150120214537.GB16828@linux> <20150121103319.14511.57709@shannon>
 <e5439ed067931dc01bda70592eb6ed52@grandegger.com>
 <20150121144323.GA17070@linux> <20150121150015.31351.6605@shannon>
 <20150121153647.GB17070@linux>
 <49707d45a389a1acb9ccec4295d05762@grandegger.com>
 <20150123060734.GA7949@Darwish.PC>
Message-ID: <20150123103213.6205.54618@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 2/5] can: kvaser_usb: Consolidate and unify state change
 handling
Date: Fri, 23 Jan 2015 10:32:13 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; gmail.com; dkim=none (message not
 signed) header.d=none;gmail.com; dmarc=permerror action=none
 header.from=marel.com;
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377424004)(24454002)(15975445007)(23676002)(87936001)(88526003)(71226002)(50466002)(77096005)(57986006)(54356999)(50986999)(76176999)(47776003)(83506001)(106466001)(2950100001)(6806004)(46102003)(33716001)(16796002)(92566002)(76506005)(19580405001)(19580395003)(86362001)(93886004)(62966003)(77156002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM2PR05MB0820;H:smtp.marel.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AM2PR05MB0820;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AM2PR05MB0820;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM2PR05MB0820;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 10:32:20.3582
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM2PR05MB0820
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ahmed S. Darwish (2015-01-23 06:07:34)
> On Wed, Jan 21, 2015 at 05:13:45PM +0100, Wolfgang Grandegger wrote:
> > On Wed, 21 Jan 2015 10:36:47 -0500, "Ahmed S. Darwish"
> > <darwish.07@gmail.com> wrote:
> > > On Wed, Jan 21, 2015 at 03:00:15PM +0000, Andri Yngvason wrote:
> > >> Quoting Ahmed S. Darwish (2015-01-21 14:43:23)
> > >> > Hi!
> > > 
> > > ...
> > > 
> > >> > <-- Unplug the cable -->
> > >> > 
> > >> >  (000.009106)  can0  20000080   [8]  00 00 00 00 00 00 08 00  
> > >> >  ERRORFRAME
> > >> >         bus-error
> > >> >         error-counter-tx-rx{{8}{0}}
> > >> >  (000.001872)  can0  20000080   [8]  00 00 00 00 00 00 10 00  
> > 
> > For a bus-errors I would also expcect some more information in the
> > data[2..3] fields. But these are always zero.
> > 
> 
> M16C error factors made it possible to report things like
> CAN_ERR_PROT_FORM/STUFF/BIT0/BIT1/TX in data[2], and
> CAN_ERR_PROT_LOC_ACK/CRC_DEL in data[3].
> 
> Unfortunately such error factors are only reported in Leaf, but
> not in USBCan-II due to the wire format change in the error event:
> 
>         struct leaf_msg_error_event {
>                 u8 tid;
>                 u8 flags;
>                 __le16 time[3];
>                 u8 channel;
>                 u8 padding;
>                 u8 tx_errors_count;
>                 u8 rx_errors_count;
>                 u8 status;
>                 u8 error_factor;
>         } __packed;
> 
>         struct usbcan_msg_error_event {
>                 u8 tid;
>                 u8 padding;
>                 u8 tx_errors_count_ch0;
>                 u8 rx_errors_count_ch0;
>                 u8 tx_errors_count_ch1;
>                 u8 rx_errors_count_ch1;
>                 u8 status_ch0;
>                 u8 status_ch1;
>                 __le16 time;
>         } __packed;
> 
> I speculate that the wire format was changed due to controller
> bugs in the USBCan-II, which was slightly mentioned in their
> data sheets here:
> 
>         http://www.kvaser.com/canlib-webhelp/page_hardware_specific_can_controllers.html
> 
> So it seems there's really no way for filling such bus error
> info given the very limited amount of data exported :-(
>
We experienced similar problems with FlexCAN.
> 
> The issue of incomplete data does not even stop here, kindly
> check below notes regarding reverse state transitions:
> 
> > >> >  ERRORFRAME
> > >> >         bus-error
> > >> >         error-counter-tx-rx{{16}{0}}
> > >> [...]
[...]
> > >> >  ERRORFRAME
> > >> >         bus-error
> > >> >         error-counter-tx-rx{{128}{0}}
> > >> > 
> > >> > (( Then a continous flood, exactly similar to the above packet,
> > >> > appears.
> > >> >    Unfortunately this flooding is a firmware problem. ))
> > >> > 
> > >> > <-- Replug the cable, after a good amount of time -->
> > >> >
> > >> Where are the reverse state transitions?
> > >> > 
> > > 
> > > Hmmm...
> > > 
> > > [ ... ]
> > >> 
> > >> Reverse state transitions are missing from the logs. See comments
> > above.
> > >> 
> > > 
> > > When the device is on the _receiving_ end, and I unplug the CAN cable
> > after
> > > introducing some noise to the level of reaching WARNING or PASSIVE, I
> > > receive a BUS_ERROR event with the rxerr count reset back to 0 or 1. In
> > > that case, the driver correctly transitions back the state to
> > ERROR_ACTIVE
> > > and candump produces something similar to:
> > > 
> > >     (000.000362)  can0  2000008C   [8]  00 40 40 00 00 00 00 01  
> > >     ERRORFRAME
> > >     controller-problem{}
> > >     protocol-violation{{back-to-error-active}{}}
> > >     bus-error
> > >     error-counter-tx-rx{{0}{1}}
> > > 
> > > which is, AFAIK, the correct behaviour from the driver side.
> > > 
> > > Meanwhile, when the device is on the _sending_ end and I re-plug the CAN
> > > cable again. Sometimes I receive events with txerr reset to 0 or 1, and
> > > the driver correctly reverts back to ERROR_ACTIVE in that case. But on
> > > another times like the quoted case above, I don't receive any events
> > > resetting txerr back -- only data packets on the bus.
> > 
> > Well, the firmware seems to report *only* bus-errors via
> > CMD_CAN_ERROR_EVENT messages, also carrying the new state, but no
> > CMD_CHIP_STATE_EVENT just for the state changes.
> > 
> 
> I've dumped _every_ message I receive from the firmware while
> disconnecting the CAN bus, waiting a while, and connecting it again.
> I really received _nothing_ from the firmware when the CAN bus was
> reconnected and the data packets were flowing again. Not even a
> single CHIP_STATE_EVENT, even after waiting for a long time.
> 
> So it's basically:
> ...
> ERR EVENT, txerr=128, rxerr=0
> ERR EVENT, txerr=128, rxerr=0
> ERR EVENT, txerr=128, rxerr=0
> ...
> 
> then complete silence, except the data frames. I've even tried with
> different versions of the firmware, but the same behaviour persisted.
> 
> > > So, What can the driver do given the above?
> > 
> > Little if the notification does not come.
> > 
> 
> We can poll the state by sending CMD_GET_CHIP_STATE to the firmware,
> and it will hopefully reply with a CHIP_STATE_EVENT response
> containing the new txerr and rxerr values that we can use for
> reverse state transitions.
>
> But do we _really_ want to go through the path? I feel that it will
> open some cans of worms w.r.t. concurrent access to both the netdev
> and USB stacks from a single driver.
>
Honestly, I don't know.
>
> A possible solution can be setting up a kernel thread that queries
> for a CHIP_STATE_EVENT every second?
> 
Have you considered polling in kvaser_usb_tx_acknowledge? You could do something
like:
if(unlikely(dev->can.state != CAN_STATE_ERROR_ACTIVE))
{
    request_state();
}

I don't think that anything beyond that would be worth pursuing.

Best regards,
Andri
