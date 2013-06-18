Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3FRXar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:30:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3FRXap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:30:45 -0400
Date: Wed, 19 Jun 2013 01:30:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Todd Showalter <todd@electronjump.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] input: document gamepad API and add extra
 keycodes
In-Reply-To: <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com>
Message-ID: <alpine.LNX.2.00.1306190129330.6750@pobox.suse.cz>
References: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com> <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jun 2013, David Herrmann wrote:

> Until today all gamepad input drivers report their data differently. It is
> nearly impossible to write applications for more than one device in a
> generic way. Therefore, this patch introduces a uniform gamepad API which
> will be used for all new drivers.
> 
> Instead of mapping buttons by their labels, we now map them by position.
> This allows applications to work with any gamepad regardless of the labels
> on the buttons. Furthermore, we standardize the ABS_* codes for analog
> triggers and sticks.
> 
> For D-Pads the long overdue BTN_DPAD_* codes are introduced. They should
> be fairly obvious how to use. To avoid confusion, the action buttons now
> have BTN_EAST/SOUTH/WEST/NORTH aliases.
> 
> Reported-by: Todd Showalter <todd@electronjump.com>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

I definitely need to have Dmitry's Ack for this. If he's OK with 1/2, I am 
fine with 2/2 patch for wiimote and will happily take it through my tree.

Thanks.

> ---
>  Documentation/input/gamepad.txt | 156 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/input.h      |   9 +++
>  2 files changed, 165 insertions(+)
>  create mode 100644 Documentation/input/gamepad.txt
> 
> diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
> new file mode 100644
> index 0000000..8002c89
> --- /dev/null
> +++ b/Documentation/input/gamepad.txt
> @@ -0,0 +1,156 @@
> +                            Linux Gamepad API
> +----------------------------------------------------------------------------
> +
> +1. Intro
> +~~~~~~~~
> +Linux provides many different input drivers for gamepad hardware. To avoid
> +having user-space deal with different button-mappings for each gamepad, this
> +document defines how gamepads are supposed to report their data.
> +
> +2. Geometry
> +~~~~~~~~~~~
> +As "gamepad" we define devices which roughly look like this:
> +
> +            ____________________________              __
> +           / [__ZL__]          [__ZR__] \               |
> +          / [__ TL __]        [__ TR __] \              | Front Triggers
> +       __/________________________________\__         __|
> +      /                                  _   \          |
> +     /      /\           __             (N)   \         |
> +    /       ||      __  |MO|  __     _       _ \        | Main Pad
> +   |    <===DP===> |SE|      |ST|   (W) -|- (E) |       |
> +    \       ||    ___          ___       _     /        |
> +    /\      \/   /   \        /   \     (S)   /\      __|
> +   /  \________ | LS  | ____ |  RS | ________/  \       |
> +  |         /  \ \___/ /    \ \___/ /  \         |      | Control Sticks
> +  |        /    \_____/      \_____/    \        |    __|
> +  |       /                              \       |
> +   \_____/                                \_____/
> +
> +       |________|______|    |______|___________|
> +         D-Pad    Left       Right   Action Pad
> +                 Stick       Stick
> +
> +                   |_____________|
> +                      Menu Pad
> +
> +Most gamepads have the following features:
> +  - Action-Pad
> +    4 buttons in diamonds-shape (on the right side). The buttons are
> +    differently labeled on most devices so we define them as NORTH,
> +    SOUTH, WEST and EAST.
> +  - D-Pad (Direction-pad)
> +    4 buttons (on the left side) that point up, down, left and right.
> +  - Menu-Pad
> +    Different constellations, but most-times 2 buttons: SELECT - START
> +    Furthermore, many gamepads have a fancy branded button that is used as
> +    special system-button. It often looks different to the other buttons and
> +    is used to pop up system-menus or system-settings.
> +  - Analog-Sticks
> +    Analog-sticks provide freely moveable sticks to control directions. Not
> +    all devices have both or any, but they are present at most times.
> +    Analog-sticks may also provide a digital button if you press them.
> +  - Triggers
> +    Triggers are located on the upper-side of the pad in vertical direction.
> +    Not all devices provide them, but the upper buttons are normally named
> +    Left- and Right-Triggers, the lower buttons Z-Left and Z-Right.
> +  - Rumble
> +    Many devices provide force-feedback features. But are mostly just
> +    simple rumble motors.
> +
> +3. Detection
> +~~~~~~~~~~~~
> +All gamepads that follow the protocol described here map BTN_GAMEPAD. This is
> +an alias for BTN_SOUTH/BTN_A. It can be used to identify a gamepad as such.
> +However, not all gamepads provide all features, so you need to test for all
> +features that you need, first. How each feature is mapped is described below.
> +
> +Legacy drivers often don't comply to these rules. As we cannot change them
> +for backwards-compatibility reasons, you need to provide fixup mappings in
> +user-space yourself. Some of them might also provide module-options that
> +change the mappings so you can adivce users to set these.
> +
> +All new gamepads are supposed to comply with this mapping. Please report any
> +bugs, if they don't.
> +
> +There are a lot of less-featured/less-powerful devices out there, which re-use
> +the buttons from this protocol. However, they try to do this in a compatible
> +fashion. For example, the "Nintendo Wii Nunchuk" provides two trigger buttons
> +and one analog stick. It reports them as if it were a gamepad with only one
> +analog stick and two trigger buttons on the right side.
> +But that means, that if you only support "real" gamepads, you must test
> +devices for _all_ reported events that you need. Otherwise, you will also get
> +devices that report a small subset of the events.
> +
> +No other devices, that do not look/feel like a gamepad, shall report these
> +events.
> +
> +4. Events
> +~~~~~~~~~
> +Gamepads report the following events:
> +
> +Action-Pad:
> +  Every gamepad device has at least 2 action buttons. This means, that every
> +  device reports BTN_SOUTH (which BTN_GAMEPAD is an alias for). Regardless
> +  of the labels on the buttons, the codes are sent according to the
> +  physical position of the buttons.
> +  Please note that 2- and 3-button pads are fairly rare and old. You might
> +  want to filter gamepads that do not report all four.
> +    2-Button Pad:
> +      If only 2 action-buttons are present, they are reported as BTN_SOUTH and
> +      BTN_EAST. For vertical layouts, the upper button is BTN_EAST. For
> +      horizontal layouts, the button more on the right is BTN_EAST.
> +    3-Button Pad:
> +      If only 3 action-buttons are present, they are reported as (from left
> +      to right): BTN_WEST, BTN_SOUTH, BTN_EAST
> +      If the buttons are aligned perfectly vertically, they are reported as
> +      (from top down): BTN_WEST, BTN_SOUTH, BTN_EAST
> +    4-Button Pad:
> +      If all 4 action-buttons are present, they can be aligned in two
> +      different formations. If diamond-shaped, they are reported as BTN_NORTH,
> +      BTN_WEST, BTN_SOUTH, BTN_EAST according to their physical location.
> +      If rectangular-shaped, the upper-left button is BTN_NORTH, lower-left
> +      is BTN_WEST, lower-right is BTN_SOUTH and upper-right is BTN_EAST.
> +
> +D-Pad:
> +  Every gamepad provides a D-Pad with four directions: Up, Down, Left, Right
> +  Some of these are available as digital buttons, some as analog buttons. Some
> +  may even report both. The kernel does not convert between these so
> +  applications should support both and choose what is more appropriate if
> +  both are reported.
> +    Digital buttons are reported as:
> +      BTN_DPAD_*
> +    Analog buttons are reported as:
> +      ABS_HAT0X and ABS_HAT0Y
> +
> +Analog-Sticks:
> +  The left analog-stick is reported as ABS_X, ABS_Y. The right analog stick is
> +  reported as ABS_RX, ABS_RY. Zero, one or two sticks may be present.
> +  If analog-sticks provide digital buttons, they are mapped accordingly as
> +  BTN_THUMBL (first/left) and BTN_THUMBR (second/right).
> +
> +Triggers:
> +  Trigger buttons can be available as digital or analog buttons or both. User-
> +  space must correctly deal with any situation and choose the most appropriate
> +  mode.
> +  Upper trigger buttons are reported as BTN_TR or ABS_HAT1X (right) and BTN_TL
> +  or ABS_HAT1Y (left). Lower trigger buttons are reported as BTN_TR2 or
> +  ABS_HAT2X (right/ZR) and BTN_TL2 or ABS_HAT2Y (left/ZL).
> +  If only one trigger-button combination is present (upper+lower), they are
> +  reported as "right" triggers (BTN_TR/ABS_HAT1X).
> +
> +Menu-Pad:
> +  Menu buttons are always digital and are mapped according to their location
> +  instead of their labels. That is:
> +    1-button Pad: Mapped as BTN_START
> +    2-button Pad: Left button mapped as BTN_SELECT, right button mapped as
> +                  BTN_START
> +  Many pads also have a third button which is branded or has a special symbol
> +  and meaning. Such buttons are mapped as BTN_MODE. Examples are the Nintendo
> +  "HOME" button, the XBox "X"-button or Sony "P" button.
> +
> +Rumble:
> +  Rumble is adverticed as FF_RUMBLE.
> +
> +----------------------------------------------------------------------------
> +  Written 2013 by David Herrmann <dh.herrmann@gmail.com>
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index 935119c..7e15565 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -507,10 +507,14 @@ struct input_keymap_entry {
>  
>  #define BTN_GAMEPAD		0x130
>  #define BTN_A			0x130
> +#define BTN_SOUTH		0x130
>  #define BTN_B			0x131
> +#define BTN_EAST		0x131
>  #define BTN_C			0x132
>  #define BTN_X			0x133
> +#define BTN_NORTH		0x133
>  #define BTN_Y			0x134
> +#define BTN_WEST		0x134
>  #define BTN_Z			0x135
>  #define BTN_TL			0x136
>  #define BTN_TR			0x137
> @@ -702,6 +706,11 @@ struct input_keymap_entry {
>  #define KEY_CAMERA_LEFT		0x219
>  #define KEY_CAMERA_RIGHT	0x21a
>  
> +#define BTN_DPAD_UP		0x220
> +#define BTN_DPAD_DOWN		0x221
> +#define BTN_DPAD_LEFT		0x222
> +#define BTN_DPAD_RIGHT		0x223
> +
>  #define BTN_TRIGGER_HAPPY		0x2c0
>  #define BTN_TRIGGER_HAPPY1		0x2c0
>  #define BTN_TRIGGER_HAPPY2		0x2c1
> -- 
> 1.8.3.1
> 

-- 
Jiri Kosina
SUSE Labs
