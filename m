Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaJJPUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:20:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59833 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaJJPUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:20:50 -0400
Date: Fri, 10 Oct 2014 10:20:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v4] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141010152044.GG31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
 <20141007142554.GE24720@saruman>
 <CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
Content-Disposition: inline
In-Reply-To: <CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 10, 2014 at 11:37:31AM +0530, Kiran Raparthy wrote:
> Hi Felipe,
> Thank you very much for taking time in reviewing the patch.
> I will try to improve the patch as per your suggestions.
> however,i have few queries which i wanted to understand from you.

sure thing.

> On 7 October 2014 19:55, Felipe Balbi <balbi@ti.com> wrote:
> >> +static int otg_wakeupsource_init(void)
> >> +{
> >> +     int ret_usb2;
> >> +     int ret_usb3;
> >> +     char wsource_name_usb2[40];
> >> +     char wsource_name_usb3[40];
> >> +     static struct usb_phy *otgws_xceiv_usb2;
> >> +     static struct usb_phy *otgws_xceiv_usb3;
> >> +
> >> +     otgws_xceiv_usb2 =3D usb_get_phy(USB_PHY_TYPE_USB2);
> >> +     otgws_xceiv_usb3 =3D usb_get_phy(USB_PHY_TYPE_USB3);
> >> +
> >> +     if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
> >> +             pr_err("%s: No OTG transceiver found\n", __func__);
> >> +             return PTR_ERR(otgws_xceiv_usb2);
> >> +     }
> >> +
> >> +     spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
> >> +     spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
> >> +
> >> +     snprintf(wsource_name_usb2, sizeof(wsource_name_usb2), "vbus-%s",
> >> +             dev_name(otgws_xceiv_usb2->dev));
> >> +     wakeup_source_init(&otgws_xceiv_usb2->wsource, wsource_name_usb2=
);
> >> +
> >> +     snprintf(wsource_name_usb3, sizeof(wsource_name_usb3), "vbus-%s",
> >> +             dev_name(otgws_xceiv_usb3->dev));
> >> +     wakeup_source_init(&otgws_xceiv_usb3->wsource, wsource_name_usb3=
);
> >> +
> >> +     otgws_xceiv_usb2->otgws_nb.notifier_call =3D otgws_otg_usb2_noti=
fications;
> >> +     ret_usb2 =3D usb_register_notifier(otgws_xceiv_usb2,
> >> +                                     &otgws_xceiv_usb2->otgws_nb);
> >> +
> >> +     otgws_xceiv_usb3->otgws_nb.notifier_call =3D otgws_otg_usb3_noti=
fications;
> >> +     ret_usb3 =3D usb_register_notifier(otgws_xceiv_usb3,
> >> +                                     &otgws_xceiv_usb3->otgws_nb);
> >> +
> >> +     if (ret_usb2 && ret_usb3) {
> >> +             pr_err("%s: usb_register_notifier on transceiver failed\=
n",
> >> +                      __func__);
> >> +             wakeup_source_trash(&otgws_xceiv_usb2->wsource);
> >> +             wakeup_source_trash(&otgws_xceiv_usb3->wsource);
> >> +             otgws_xceiv_usb2 =3D NULL;
> >> +             otgws_xceiv_usb3 =3D NULL;
> >> +             return ret_usb2 | ret_usb3;
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +late_initcall(otg_wakeupsource_init);
> >
> > you guys are really not getting what I mean. I asked for this to be
> > built into the core itself. This means that you shouldn't need to use
> > notifications nor should you need to call usb_get_phy(). You're part of
> > the PHY framework.
> >
> > All this late_initcall() nonsense should go.
> >
> > This code won't even work if we have more than one phy of the same type
> > (AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
> > USB2 PHYs), because you can't grab the PHY you want.
>=20
> Apologies,I am new to usb sub system,so i missed this point before i
> posted my patch,Thanks for the information.

np.

> > What you need is to:
> >
> > 1) make PHY notifiers generic (move all of that phy-core.c)
> From the above points,you mentioned that "if we built it into core,we
> shouldn't need to use notifications"
> and your first point here says that make phy notifiers generic in phy-cor=
e.c
> can you help me understanding it better so that there wont be any
> understanding gap.

yeah, notifiers should go but if you really must use them, then at least
make all of that generic ;-)

> > 2) introduce usb_phy_set_event(phy, event) (which just sets the even to=
 a
> >         phy->event member for now)
> > 3) make all PHY drivers use usb_phy_set_event()
> > 4) add the following to usb_phy_set_event()
> >
> >         switch (event) {
> >         case USB_EVENT_ENUMERATED:
> >                 pm_stay_awake(&otgws_xceiv->wsource);
> >                 break;
> >
> >         case USB_EVENT_NONE:
> >         case USB_EVENT_VBUS:
> >         case USB_EVENT_ID:
> >         case USB_EVENT_CHARGER:
> >                 pm_wakeup_event(&otgws_xceiv->wsource,
> >                                 msecs_to_jiffies(TEMPORARY_HOLD_TIME));
> >                 break;
> >
> >         default:
> >                 break;
> >         }
> >
> Once the phy drivers receives per-PHY event notification(if we use
> notifier,else "for any event") we can call usb_phy_set_event from phy
> driver to hold the wakeup source.
> Please correct me if my understanding is incorrect.

yeah. In fact, you can call usb_phy_set_event() directly from PHY's IRQ
handler.

> I have gone through some phy drivers in drivers/phy,since the each
> driver implementation is different from others, i didn't get the best
> place in  PHY driver
> where we can trigger(use phy-core functionality) per-PHY notifier
> registration. any pointers here?

registration ? probe(), they all have probe() functions. Now to figure
out where to call usb_phy_set_event(). That's something completely
different, and that's where the core of this change is :-)

For PHYs which have IRQ lines, easy: just call usb_phy_set_event() from
IRQ handler. For those who don't, then it's a little more difficult and
will require your investigation.

--=20
balbi

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUN/lMAAoJEIaOsuA1yqRE6XwP/2an+I2qV6U9/pBg4/61idlA
5CyDKb9pQzCdWd7YaAugjTE+ACqy9t1vj+qhwwYePCuPwRRq1gYVC3fk14Sp6jqO
s8XtnhGH6k4USsTWs5GxEdzK8DXbbeiiX0lfXdSePgVeBcuTpo4lUilIMER7iTsG
OfiI6BGewNSprIzSqKaRsff9t8Z7YUvT+AOBd0pv2r6x71pIYWEzSXRSvoi80ajR
/+5kDquR++2H2XkorOBMroIvbBQT1BX/XXiwwdfH542C4stX3eRD9ZVqNNTK3dM1
/qBuEoW2tr7G5Ml5hBBJJn/HinMfav/pfi0IeEU1VlUHPcUXpNt/iuFADTq1ny0+
esuM+e4BnoqUDPWWEUYVTAn8Y0/NYUWuZIWSIQIhl9EYAkJyMIa3tY/e/mPHiCuV
TY9QybwZvVJfrS05WRoZztrg65dQRBJxx0+avxShLFMN+28wwehtknj0NfSgYtzt
1oLzRRVfbd3+oLVKx7gfjBVU+GZMhqhMVyTkVVAkec40yAUK9bvEX3lvbIbFV766
JcH7r7+7P3PQSFY+KBMrKd5jvA4SWgenNw4673SMjI4Ov9ycLZK33gdgbfq/bh15
4/Xfn9j5LsH8EcLnhmra3W0cnlOkDrb99tZ02kkW8xsDtS8Mm1FSkUl9Esd8lGuZ
EQnw9aqF77JDbgdVdELK
=INWu
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--
