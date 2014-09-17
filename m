Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaIQHqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:46:00 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54524 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaIQHp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:45:59 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 17 Sep 2014 09:45:42 +0200
X-Google-Sender-Auth: jMZvSeJ8zObCRZ0asCBkAqBaPng
Message-ID: <CAL8zT=g6ibhGpAJtSaGPNeGmm0kwyjAb=JWgYMHp37P8XAFFCQ@mail.gmail.com>
Subject: SGTL5000 on i.MX6 in I2S master mode
To: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a custom i.MX6 board, and have a sgtl5000 connected on it. I
would like to have it used in master mode (it is used only for audio
capture) but I get a "pcm_read:2031: read error: Input/output error"
when using arecord.
I am wondering if I forgot something in my DT or if I need to do
something else :

    sound {
        compatible = "fsl,imx6q-vbx3-sgtl5000",
                 "fsl,imx-audio-sgtl5000";
        model = "imx6q-vbx3-sgtl5000";
        ssi-controller = <&ssi1>;
        audio-codec = <&codec>;
        audio-routing =
            "LINE_IN", "Line In Jack";
        mux-int-port = <1>;
        mux-ext-port = <5>;
    };

&audmux {
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_audmux>;
    status = "okay";
};

&i2c2 {
    clock-frequency = <100000>;
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_i2c2>;
    status = "okay";

    codec: sgtl5000@0a {
        compatible = "fsl,sgtl5000";
        reg = <0x0a>;
        clocks = <&clks 201>;
        VDDA-supply = <&vgen6_reg>;
        VDDIO-supply = <&vgen6_reg>;
        sysclk = <24000000>;
    };
};

&iomuxc {
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_hog>;

    imx6qdl-vbx3 {
        pinctrl_audmux: audmuxgrp {
            fsl,pins = <
                MX6QDL_PAD_DISP0_DAT13__AUD5_RXFS        0x130b0
                MX6QDL_PAD_DISP0_DAT14__AUD5_RXC        0x130b0
                MX6QDL_PAD_DISP0_DAT16__AUD5_TXC        0x130b0
                MX6QDL_PAD_DISP0_DAT18__AUD5_TXFS        0x130b0
                MX6QDL_PAD_DISP0_DAT19__AUD5_RXD        0x130b0
            >;
        };
};

&ssi1 {
    status = "okay";
    codec-handle = <&codec>;
    fsl,mode = "i2s-master";
    fsl,ssi-asynchronous;
};

FYI, AUD5_TXC is wirely connected to AUD5_RXC and AUD5_TXFS is
connected to AUD5_RXFS.

Here is the dmesg part :
[    6.026803] sgtl5000 1-000a: sgtl5000 revision 0x11
[    6.129380] imx-sgtl5000 sound: snd_soc_register_card failed (-517)
[    6.248849] platform sound: Driver imx-sgtl5000 requests probe deferral
[    6.311643] sgtl5000 1-000a: Using internal LDO instead of VDDD
[    6.393196] imx-sgtl5000 sound: sgtl5000 <-> 2028000.ssi mapping ok

And the user space commands :
$> arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: imx6qvbx3sgtl50 [imx6q-vbx3-sgtl5000], device 0: HiFi sgtl5000-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0

$> arecord -v -V stereo -fdat -D hw:0,0 somefile.wav
Recording WAVE 'somefile.wav' : Signed 16 bit Little Endian, Rate
48000 Hz, Stereo
Hardware PCM card 0 'imx6q-vbx3-sgtl5000' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 1
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
  appl_ptr     : 0
  hw_ptr       : 0
arecord: pcm_read:2031: read error: Input/output error

The kernel is 3.17-rc5.

Thanks for reading all this, and for any advice :).
JM
